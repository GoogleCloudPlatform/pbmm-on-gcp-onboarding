/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/



resource "google_compute_instance" "virtual_machine" {
  project        = var.project
  name           = module.vm_name.result_lower
  machine_type   = var.machine_type
  zone           = var.vm_zone
  tags           = local.network_tags
  hostname       = "${module.vm_name.result_lower}.${var.project}.${var.domain}"
  can_ip_forward = var.can_ip_forward
  metadata       = var.metadata
  boot_disk {
    device_name = module.boot_disk_name.result
    initialize_params {
      image = "${var.image_location}/${var.image}"
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  metadata_startup_script = var.metadata_startup_script != null ? var.metadata_startup_script != "" : null

  dynamic "attached_disk" {
    for_each = { for disk in var.disks : disk.id => disk }
    content {
      source      = module.data_disk_name[attached_disk.value.id].result_lower
      device_name = module.data_disk_name[attached_disk.value.id].result_lower
    }
  }

  dynamic "network_interface" {
    for_each = { for ni in var.network_interfaces : ni.id => ni }
    content {
      subnetwork         = network_interface.value.subnetwork
      subnetwork_project = network_interface.value.subnetwork_project
      network_ip         = lookup(network_interface.value, "network_ip", null)
      dynamic "access_config" {
        for_each = { for ac in(lookup(network_interface.value, "access_config") == null ? [] : network_interface.value.access_config) : ac.nat_ip => ac }
        content {
          nat_ip       = access_config.value.nat_ip
          network_tier = "STANDARD"
        }
      }
    }
  }

  service_account {
    scopes = var.service_account_scopes
    email  = var.service_account_email_address
  }
  labels     = var.labels
  depends_on = [google_compute_disk.vm_disk]
}

resource "google_compute_disk" "vm_disk" {
  for_each = { for d in var.disks : d.id => d }

  project = var.project
  name    = module.data_disk_name[each.value.id].result_lower
  type    = each.value.type
  size    = each.value.size
  zone    = var.vm_zone
  labels  = var.labels
}

resource "google_compute_disk_resource_policy_attachment" "os_disk_attachment" {
  count      = var.compute_resource_policy != "" ? 1 : 0
  project    = var.project
  name       = var.compute_resource_policy
  disk       = google_compute_instance.virtual_machine.name
  zone       = var.vm_zone
  depends_on = [google_compute_disk.vm_disk]
}

resource "google_compute_disk_resource_policy_attachment" "additional_disk_attachment" {
  for_each   = { for d in var.disks : d.id => d if var.compute_resource_policy_non_bootdisk != "" }
  project    = var.project
  name       = var.compute_resource_policy_non_bootdisk
  disk       = module.data_disk_name[each.value.id].result_lower
  zone       = var.vm_zone
  depends_on = [google_compute_disk.vm_disk]
}
