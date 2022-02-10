/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "random_password" "fgt_ha_password" {
  length = 16
}

data "google_compute_subnetwork" "subnetworks" {
  for_each = var.network_ports
  project  = each.value.project
  name     = each.value.subnetwork
  region   = var.region
}

# reserve IPs for the initial active instance on all networks
resource "google_compute_address" "active" {
  for_each     = var.network_ports
  project      = var.project
  name         = module.compute_address_internal_active_ip[each.key].result
  subnetwork   = data.google_compute_subnetwork.subnetworks[each.key].name
  address_type = "INTERNAL"
  region       = var.region
}

# reserve Public IPs for the initial active instance on all networks
resource "google_compute_address" "public_active" {
  project      = var.project
  name         = module.compute_address_public_active_ip.result
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
}

# reserve IPs for the initial passive instance on all networks
resource "google_compute_address" "passive" {
  for_each     = var.network_ports
  project      = var.project
  name         = module.compute_address_internal_passive_ip[each.key].result
  subnetwork   = data.google_compute_subnetwork.subnetworks[each.key].name
  address_type = "INTERNAL"
  region       = var.region
}

# reserve Public IPs for the initial active instance on all networks
resource "google_compute_address" "public_passive" {
  project      = var.project
  name         = module.compute_address_public_passive_ip.result
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
}

# route that is used by the SDN connector, modified by the appliance when active instance changes
resource "google_compute_route" "internal" {
  name        = "internal-route"
  project     = data.google_compute_subnetwork.subnetworks[var.internal_port].project
  dest_range  = "0.0.0.0/0"
  network     = data.google_compute_subnetwork.subnetworks[var.internal_port].network
  next_hop_ip = google_compute_address.active[var.internal_port].address
  priority    = 100

  # ignore changes to the next_hop_ip as it is maintained by the Fortigate SDN connector
  lifecycle {
    ignore_changes = [
      next_hop_ip,
    ]
  }
}

# copy image to our project and add multi-nic feature
resource "google_compute_image" "fortios" {
  project      = var.project
  name         = "${var.image}-multi-nic"
  source_image = "https://www.googleapis.com/compute/v1/projects/${var.image_location}/global/images/${var.image}"
  guest_os_features {
    type = "MULTI_IP_SUBNET"
  }
}

resource "google_service_account" "fortigate_service_account" {
  account_id   = module.fortigate_service_account.result_lower
  display_name = "Fortigate Applicances' Service Account"
  project      = var.project
}

# give SA editor in the project that holds the internal network,
# permissions should be investigated to give a minimal requirement
resource "google_project_iam_member" "internal_network_project" {
  project = data.google_compute_subnetwork.subnetworks[var.internal_port].project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.fortigate_service_account.email}"
}

# give SA viewer in project where devices reside
resource "google_project_iam_member" "fortigate_project" {
  project = var.project
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.fortigate_service_account.email}"
}

module "instances" {
  for_each = local.instances
  source   = "../terraform-virtual-machine"

  project             = var.project
  vm_zone             = each.value.zone
  machine_type        = var.machine_type
  image               = google_compute_image.fortios.name
  image_location      = var.project
  user_defined_string = var.user_defined_string
  environment         = var.environment
  department_code     = var.department_code
  device_type         = "FWL"
  network_tags        = local.concat_network_tags
  can_ip_forward      = true
  number_suffix       = each.value.number_suffix
  location            = var.location

  metadata = {
    user-data = data.template_file.metadata[each.key].rendered
    // license            = file("${path.module}/${each.value.license_key}") # this is where to put the license file if using BYOL image "
    serial-port-enable = true
  }

  service_account_email_address        = google_service_account.fortigate_service_account.email
  service_account_scopes               = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  compute_resource_policy              = var.compute_resource_policy
  compute_resource_policy_non_bootdisk = var.compute_resource_policy_non_bootdisk

  network_interfaces = [
    {
      id                 = 0
      subnetwork         = data.google_compute_subnetwork.subnetworks["port1"].name
      subnetwork_project = data.google_compute_subnetwork.subnetworks["port1"].project
      network_ip         = each.value.port1_ip
      access_config      = [
        {
            nat_ip       = each.value.public_ip
        },
      ]
    },
    {
      id                 = 1
      subnetwork         = data.google_compute_subnetwork.subnetworks["port2"].name
      subnetwork_project = data.google_compute_subnetwork.subnetworks["port2"].project
      network_ip         = each.value.port2_ip
    },
    {
      id                 = 2
      subnetwork         = data.google_compute_subnetwork.subnetworks["port3"].name
      subnetwork_project = data.google_compute_subnetwork.subnetworks["port3"].project
      network_ip         = each.value.port3_ip
    },
    {
      id                 = 3
      subnetwork         = data.google_compute_subnetwork.subnetworks["port4"].name
      subnetwork_project = data.google_compute_subnetwork.subnetworks["port4"].project
      network_ip         = each.value.port4_ip
    },
  ]

  # Log Disk
  disks = [
    {
      id   = 1
      size = 20
      type = "pd-ssd"
    }
  ]
  depends_on = [
    google_compute_address.active,
    google_compute_address.public_active,
    google_compute_address.passive,
    google_compute_address.public_passive,
  ]
}
