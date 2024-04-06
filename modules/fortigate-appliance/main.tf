/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Generate a random string as admin password
resource "random_password" "fgt_ha_password" {
  length = 16
}

# Randomize string to avoid duplication
resource "random_string" "random_name_post" {
  length           = 3
  special          = true
  override_special = ""
  min_lower        = 3
}

data "google_compute_subnetwork" "subnetworks" {
  for_each = var.network_ports
  project  = each.value.project
  name     = each.value.subnetwork
  region   = var.region
}

# Copy image to our project and add gvnic feature
resource "google_compute_image" "fortios_image_gvnic" {
  count             = var.nictype == "GVNIC" ? 1 : 0
  provider          = google-beta
  project           = var.project
  name              = "${var.image_name}-gvnic"
  source_image      = "https://www.googleapis.com/compute/v1/projects/${var.image_project}/global/images/${var.image_name}"
  storage_locations = [var.location]
  guest_os_features {
    type = var.nictype
  }
}

# reserve IPs for the initial active instance on all networks
resource "google_compute_address" "active" {
  for_each     = var.network_ports
  project      = var.project
  name         = module.compute_address_internal_active_ip[each.key].result
  subnetwork   = data.google_compute_subnetwork.subnetworks[each.key].name
  address_type = "INTERNAL"
  region       = var.region
  lifecycle {
    ignore_changes = all
  }
}

# reserve Public IPs for the initial active instance on all networks
resource "google_compute_address" "public_active" {
  project      = var.project
  name         = module.compute_address_public_active_ip.result
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
  lifecycle {
    ignore_changes = all
  }
}

# reserve IPs for the initial passive instance on all networks
resource "google_compute_address" "passive" {
  for_each     = var.network_ports
  project      = var.project
  name         = module.compute_address_internal_passive_ip[each.key].result
  subnetwork   = data.google_compute_subnetwork.subnetworks[each.key].name
  address_type = "INTERNAL"
  region       = var.region
  lifecycle {
    ignore_changes = all
  }
}

# reserve Public IPs for the initial active instance on all networks
resource "google_compute_address" "public_passive" {
  project      = var.project
  name         = module.compute_address_public_passive_ip.result
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
  lifecycle {
    ignore_changes = all
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

# FGT-VM Instance template
resource "google_compute_instance_template" "ftgvm_instance_templates" {
  for_each    = local.instances
  project     = var.project
  name        = "${lower(each.key)}-fgtvm-template-${random_string.random_name_post.result}"
  description = "FGT-${upper(each.key)}-VM Instance Template"

  instance_description = "FGT-${upper(each.key)}-VM Instance"
  machine_type         = var.machine_type
  can_ip_forward       = true

  tags = local.concat_network_tags

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Create a new boot disk from an image
  disk {
    source_image = google_compute_image.fortios_image_gvnic[0].self_link
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
    subnetwork = data.google_compute_subnetwork.subnetworks[var.public_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port1_ip
  }

  # Private Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.internal_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port2_ip
  }

  # HA Sync Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.ha_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port3_ip
  }

  # Mgmt Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.mgmt_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port4_ip
    access_config {
      nat_ip = each.value.mgmt_ip
    }
  }

  # Metadata to bootstrap FGT
  metadata = {
    user-data              = data.template_file.metadata[each.key].rendered
    license                = var.license_type == "BYOL" && fileexists("${path.module}/files/${each.value.license_key}") ? file("${path.module}/files/${each.value.license_key}") : null
    block-project-ssh-keys = "TRUE"
  }

  # Email will be the service account
  service_account {
    email  = google_service_account.fortigate_service_account.email
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
}

# FGT-VM Instances
resource "google_compute_instance_from_template" "fgtvm_instances" {
  for_each                 = local.instances
  project                  = var.project
  name                     = "${lower(each.key)}-fgtvm-${random_string.random_name_post.result}"
  zone                     = each.value.zone
  source_instance_template = google_compute_instance_template.ftgvm_instance_templates[each.key].self_link

  # Public Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.public_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port1_ip
  }

  # Private Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.internal_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port2_ip
  }

  # HA Sync Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.ha_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port3_ip
  }

  # Mgmt Network
  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetworks[var.mgmt_port].self_link
    nic_type   = var.nictype
    network_ip = each.value.port4_ip
    access_config {
      nat_ip = each.value.mgmt_ip
    }
  }

  depends_on = [
    google_compute_address.active,
    google_compute_address.public_active,
    google_compute_address.passive,
    google_compute_address.public_passive,
    google_compute_router_nat.public_nat,
  ]

  lifecycle {
    ignore_changes = all
  }
}

# Create static cluster ip for external pass-through nlb
resource "google_compute_address" "cluster_sip" {
  project = var.project
  region  = var.region
  name    = "cluster-ip-${random_string.random_name_post.result}"
  lifecycle {
    ignore_changes = all
  }
}

# Create static active instance management ip
resource "google_compute_address" "active_instance_mgmt_sip" {
  project = var.project
  region  = var.region
  name    = "active-fgtvm-mgmt-ip-${random_string.random_name_post.result}"
  lifecycle {
    ignore_changes = all
  }
}

# Create static passive instance management ip
resource "google_compute_address" "passive_instance_mgmt_sip" {
  project = var.project
  region  = var.region
  name    = "passive-fgtvm-mgmt-ip-${random_string.random_name_post.result}"
  lifecycle {
    ignore_changes = all
  }
}
