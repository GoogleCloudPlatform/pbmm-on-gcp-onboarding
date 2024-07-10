#### External Load Balancer ###
### Forwarding Rule ###
resource "google_compute_forwarding_rule" "external" {
  name       = "external-lb-${random_string.random_name_post.result}"
  region     = local.default_region
  ip_address = google_compute_address.static.address

  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_pool.external.self_link
}

### Target Pools ###
resource "google_compute_target_pool" "external" {
  name             = "fgt-instancepool-${random_string.random_name_post.result}"
  region           = local.default_region
  session_affinity = "CLIENT_IP"

  instances = [google_compute_instance_from_template.active_fgt_instance.self_link, google_compute_instance_from_template.passive_fgt_instance.self_link]

  health_checks = [
    google_compute_http_health_check.external.name
  ]
}

### Health Check ###
resource "google_compute_http_health_check" "external" {
  name                = "health-check-backend-${random_string.random_name_post.result}"
  check_interval_sec  = 3
  timeout_sec         = 2
  unhealthy_threshold = 3
  port                = "8008"
}


### Internal ###
resource "google_compute_address" "internal_address" {
  name         = "internal-ilb-address-${random_string.random_name_post.result}"
  subnetwork   = local.vpc_subnets_self_links[0]
  address_type = "INTERNAL"
  address      = local.internal_ilb_address
  region       = local.default_region
}

resource "google_compute_forwarding_rule" "internal_load_balancer" {
  name       = "internal-slb-${random_string.random_name_post.result}"
  region     = local.default_region
  ip_address = google_compute_address.internal_address.address

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal_load_balancer_backend.self_link
  all_ports             = true
  network               = local.vpc_private_network_self_link
  subnetwork            = local.vpc_subnets_self_links[0]
}

resource "google_compute_region_backend_service" "internal_load_balancer_backend" {
  name                            = "internal-slb-backend-${random_string.random_name_post.result}"
  region                          = local.default_region
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
  network                         = local.vpc_private_network_self_link


  backend {
    group = google_compute_instance_group.umig_active.self_link
  }

  backend {
    group = google_compute_instance_group.umig_passive.self_link
  }

  health_checks = [
    google_compute_health_check.hc.self_link
  ]
}

resource "google_compute_health_check" "hc" {
  name               = "internal-slb-healthcheck-${random_string.random_name_post.result}"
  check_interval_sec = 3
  timeout_sec        = 2
  tcp_health_check {
    port = "8008"
  }
}

resource "google_compute_image" "fgtvmgvnic" {
  count = var.nictype == "GVNIC" ? 1 : 0
  name  = "fgtvmgvnic-image"

  source_image = var.image

  guest_os_features {
    type = var.nictype
  }
}

# Active FGT Instance template
resource "google_compute_instance_template" "active" {
  name        = "active-fgt-template-${random_string.random_name_post.result}"
  description = "FGT-Active Instance Template"

  instance_description = "FGT-Active Instance Template"
  machine_type         = var.machine
  can_ip_forward       = true

  tags = ["allow-fgt", "allow-internal", "allow-sync", "allow-mgmt"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Create a new boot disk from an image
  disk {
    source_image = var.nictype == "GVNIC" ? google_compute_image.fgtvmgvnic[0].self_link : var.image
    auto_delete  = true
    boot         = true
  }

  # Log Disk
  disk {
    auto_delete  = true
    boot         = false
    disk_size_gb = 30
  }

  # Public Network
  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.name
    nic_type   = var.nictype
    network_ip = var.active_port1_ip
  }

  # Private Network
  network_interface {
    subnetwork = local.vpc_subnets_names[0]
    nic_type   = var.nictype
    network_ip = local.private_active_address
  }

  # HA Sync Network
  network_interface {
    subnetwork = google_compute_subnetwork.sync_subnet.name
    nic_type   = var.nictype
    network_ip = var.active_port3_ip
  }

  # Mgmt Network
  network_interface {
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    nic_type   = var.nictype
    network_ip = var.active_port4_ip
  }

  # Metadata to bootstrap FGT
  metadata = {
    user-data = templatefile("${path.module}/active", {
      active_port1_ip          = var.active_port1_ip
      active_port1_mask        = var.active_port1_mask
      active_port2_ip          = local.private_active_address
      active_port2_mask        = var.active_port2_mask
      active_port3_ip          = var.active_port3_ip
      active_port3_mask        = var.active_port3_mask
      active_port4_ip          = var.active_port4_ip
      active_port4_mask        = var.active_port4_mask
      mgmt_gateway_ip          = var.mgmt_gateway     //  mgmt gateway ip
      passive_hb_ip            = var.passive_port3_ip // passive hb ip
      hb_netmask               = var.mgmt_mask        // mgmt netmask
      port1_gateway            = google_compute_subnetwork.public_subnet.gateway_address
      port2_gateway            = local.private_network_gateway
      clusterip                = "cluster-ip-${random_string.random_name_post.result}"
      internalroute            = "internal-route-${random_string.random_name_post.result}"
      internal_loadbalancer_ip = google_compute_address.internal_address.address
      public_subnet            = var.public_subnet
      # TODO private_subnet vs primary_region_subnet?
      private_subnet        = local.vpc_subnets_ips[0]
      fgt_public_ip         = "${google_compute_address.static.address}"
      hub_base_subnet       = var.hub_base_subnet
      primary_region_subnet = local.vpc_subnet_ips[0]
    })
    license                = fileexists("${path.module}/${var.licenseFile}") ? "${file(var.licenseFile)}" : null
    block-project-ssh-keys = "TRUE"
  }

  # Email will be the service account
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
}


# Compute template for passive node
#
resource "google_compute_instance_template" "passive" {
  name        = "passive-fgt-template-${random_string.random_name_post.result}"
  description = "FGT-Passive Instance Template"

  instance_description = "FGT-Passive Instance Template"
  machine_type         = var.machine
  can_ip_forward       = true

  tags = ["allow-fgt", "allow-internal", "allow-sync", "allow-mgmt"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Create a new boot disk from an image
  disk {
    source_image = var.nictype == "GVNIC" ? google_compute_image.fgtvmgvnic[0].self_link : var.image
    auto_delete  = true
    boot         = true
  }

  # Log Disk
  disk {
    auto_delete  = true
    boot         = false
    disk_size_gb = 30
  }

  # Public Network
  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.name
    nic_type   = var.nictype
    network_ip = var.passive_port1_ip
  }

  # Private Network
  network_interface {
    subnetwork = local.vpc_subnets_names[0]
    nic_type   = var.nictype
    network_ip = local.private_passive_address
  }

  # HA Sync Network
  network_interface {
    subnetwork = google_compute_subnetwork.sync_subnet.name
    nic_type   = var.nictype
    network_ip = var.passive_port3_ip
  }

  # Mgmt Network
  network_interface {
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    nic_type   = var.nictype
    network_ip = var.passive_port4_ip
  }

  metadata = {
    user-data = templatefile("${path.module}/passive", {
      passive_port1_ip         = var.passive_port1_ip
      passive_port1_mask       = var.passive_port1_mask
      passive_port2_ip         = local.private_passive_address
      passive_port2_mask       = var.passive_port2_mask
      passive_port3_ip         = var.passive_port3_ip
      passive_port3_mask       = var.passive_port3_mask
      passive_port4_ip         = var.passive_port4_ip
      passive_port4_mask       = var.passive_port4_mask
      mgmt_gateway_ip          = var.mgmt_gateway    //  mgmt gateway ip
      active_hb_ip             = var.active_port3_ip // active hb ip
      hb_netmask               = var.mgmt_mask       // mgmt netmask
      port1_gateway            = google_compute_subnetwork.public_subnet.gateway_address
      port2_gateway            = local.private_network_gateway
      clusterip                = "cluster-ip-${random_string.random_name_post.result}"
      internalroute            = "internal-route-${random_string.random_name_post.result}"
      internal_loadbalancer_ip = google_compute_address.internal_address.address
      public_subnet            = var.public_subnet
      private_subnet           = local.vpc_subnets_ips[0]
      fgt_public_ip            = "${google_compute_address.static.address}"
    })
    license                = fileexists("${path.module}/${var.licenseFile2}") ? "${file(var.licenseFile2)}" : null
    block-project-ssh-keys = "TRUE"
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
}


#
# FGT Active FGT
#
resource "google_compute_instance_from_template" "active_fgt_instance" {
  name                     = "activefgt-${random_string.random_name_post.result}"
  zone                     = var.zone
  source_instance_template = google_compute_instance_template.active.self_link

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.name
    nic_type   = var.nictype
    network_ip = var.active_port1_ip
  }
  network_interface {
    subnetwork = local.vpc_subnets_names[0]
    nic_type   = var.nictype
    network_ip = local.private_active_address
  }
  network_interface {
    subnetwork = google_compute_subnetwork.sync_subnet.name
    nic_type   = var.nictype
    network_ip = var.active_port3_ip
  }
  network_interface {
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    nic_type   = var.nictype
    network_ip = var.active_port4_ip
    access_config {
      nat_ip = google_compute_address.static2.address
    }
  }
}

#
# FGT Passive FGT
#
resource "google_compute_instance_from_template" "passive_fgt_instance" {
  depends_on               = [google_compute_instance_from_template.active_fgt_instance]
  name                     = "passivefgt-${random_string.random_name_post.result}"
  zone                     = var.zone
  source_instance_template = google_compute_instance_template.passive.self_link

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.name
    nic_type   = var.nictype
    network_ip = var.passive_port1_ip
  }
  network_interface {
    subnetwork = local.vpc_subnets_names[0]
    nic_type   = var.nictype
    network_ip = local.private_passive_address
  }
  network_interface {
    subnetwork = google_compute_subnetwork.sync_subnet.name
    nic_type   = var.nictype
    network_ip = var.passive_port3_ip
  }
  network_interface {
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    nic_type   = var.nictype
    network_ip = var.passive_port4_ip
    access_config {
      nat_ip = google_compute_address.static3.address
    }
  }
}

###########################
# UnManaged Instance Group
###########################
resource "google_compute_instance_group" "umig_active" {
  name    = "unmanage-active-${random_string.random_name_post.result}"
  project = local.vpc_private_network_project_id
  zone    = var.zone
  instances = matchkeys(
    google_compute_instance_from_template.active_fgt_instance.*.self_link,
    google_compute_instance_from_template.active_fgt_instance.*.zone,
    [var.zone],
  )
}

resource "google_compute_instance_group" "umig_passive" {
  name    = "unmanage-passive-${random_string.random_name_post.result}"
  project = local.vpc_private_network_project_id
  zone    = var.zone
  instances = matchkeys(
    google_compute_instance_from_template.passive_fgt_instance.*.self_link,
    google_compute_instance_from_template.passive_fgt_instance.*.zone,
    [var.zone],
  )
}
