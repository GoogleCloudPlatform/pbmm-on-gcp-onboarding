/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  network_tags = []

  concat_network_tags = distinct(concat(local.network_tags, var.network_tags))
  IAP_subnet          = "35.235.240.0/20"

  port_nic = {
    port1 = 0
    port2 = 1
    port3 = 2
    port4 = 3
  }

  instances = {
    active = {
      priority      = 255
      number_suffix = "01"
      zone          = "northamerica-northeast1-a"
      license_key   = "FGVM08TM21002329.lic"
      port1_ip      = google_compute_address.active["port1"].address
      port2_ip      = google_compute_address.active["port2"].address
      port3_ip      = google_compute_address.active["port3"].address
      port4_ip      = google_compute_address.active["port4"].address
      ha_ip         = google_compute_address.active[var.ha_port].address
      peer_ip       = google_compute_address.passive[var.ha_port].address
      public_ip     = google_compute_address.public_active.address
    }
    passive = {
      priority      = 0
      number_suffix = "02"
      zone          = "northamerica-northeast1-b"
      license_key   = "FGVM08TM21002330.lic"
      port1_ip      = google_compute_address.passive["port1"].address
      port2_ip      = google_compute_address.passive["port2"].address
      port3_ip      = google_compute_address.passive["port3"].address
      port4_ip      = google_compute_address.passive["port4"].address
      ha_ip         = google_compute_address.passive[var.ha_port].address
      peer_ip       = google_compute_address.active[var.ha_port].address
      public_ip     = google_compute_address.public_passive.address
    }
  }
}