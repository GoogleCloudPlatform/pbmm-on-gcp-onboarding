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

locals {
  network_tags = ["allow-fgt-public-ingress", "allow-fgt-external-ingress", "allow-ftg-healthchecks-ingress", "allow-ftg-internal-ingress", "allow-ftg-sync-ingress", "allow-ftg-mgmt-ingress", "allow-ftg-internet-egress"]

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
      zone          = "${var.region}-${var.zone_1}"
      license_key   = "FGVM08TM21002329.lic"
      port1_ip      = google_compute_address.active[var.public_port].address   # active port1 private ip
      port2_ip      = google_compute_address.active[var.internal_port].address # active instance port2 private ip
      port3_ip      = google_compute_address.active[var.ha_port].address       # active instance port3 private ip
      port4_ip      = google_compute_address.active[var.mgmt_port].address     # active instance port4 private ip
      peer_ip       = google_compute_address.passive[var.ha_port].address      # active instance ha peer (passive) private ip
      mgmt_ip       = google_compute_address.active_instance_mgmt_sip.address  # active instance mgmt static ip
    }
    passive = {
      priority      = 0
      number_suffix = "02"
      zone          = "${var.region}-${var.zone_2}"
      license_key   = "FGVM08TM21002330.lic"
      port1_ip      = google_compute_address.passive[var.public_port].address   # passive instance port1 private ip
      port2_ip      = google_compute_address.passive[var.internal_port].address # passive instance port2 private ip
      port3_ip      = google_compute_address.passive[var.ha_port].address       # passive instance port3 private ip
      port4_ip      = google_compute_address.passive[var.mgmt_port].address     # passive instance port4 private ip
      peer_ip       = google_compute_address.active[var.ha_port].address        # passive instance ha peer (active) private ip
      mgmt_ip       = google_compute_address.passive_instance_mgmt_sip.address  # passive instance mgmt static ip
    }
  }
}
