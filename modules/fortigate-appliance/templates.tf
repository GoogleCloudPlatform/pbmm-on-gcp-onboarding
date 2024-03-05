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

data "template_file" "metadata" {
  for_each = local.instances
  template = file("${path.module}/templates/metadata.tpl")
  vars = {
    # config system global
    hostname = "${module.vm_name[each.key].result}-${each.value.number_suffix}"
    # config system admin
    admin_password = random_password.fgt_ha_password.result
    # config system interface
    port1                    = var.public_port
    port1_ip                 = each.value.port1_ip
    port1_mask               = "255.255.255.255"
    port2                    = var.internal_port
    port2_ip                 = each.value.port2_ip
    port2_mask               = "255.255.255.255"
    port3                    = var.ha_port
    port3_ip                 = each.value.port3_ip
    port3_mask               = cidrnetmask(data.google_compute_subnetwork.subnetworks[var.ha_port].ip_cidr_range)
    port4                    = var.mgmt_port
    port4_ip                 = each.value.port4_ip
    port4_mask               = cidrnetmask(data.google_compute_subnetwork.subnetworks[var.mgmt_port].ip_cidr_range)
    external_ilbnh_ip = google_compute_address.external_ilbnh_address.address
    internal_ilbnh_ip = google_compute_address.internal_ilbnh_address.address
    # config system ha
    hamgmt_port       = var.mgmt_port
    hamgmt_gateway_ip = data.google_compute_subnetwork.subnetworks[var.mgmt_port].gateway_address
    ha_priority       = each.value.priority
    hb_ip             = each.value.peer_ip
    hb_netmask        = cidrnetmask(data.google_compute_subnetwork.subnetworks[var.mgmt_port].ip_cidr_range)
    # config router static
    port1_gateway  = data.google_compute_subnetwork.subnetworks[var.public_port].gateway_address
    public_subnet  = data.google_compute_subnetwork.subnetworks[var.public_port].ip_cidr_range
    private_subnet = data.google_compute_subnetwork.subnetworks[var.internal_port].ip_cidr_range
    port2_gateway  = data.google_compute_subnetwork.subnetworks[var.internal_port].gateway_address
    # config firewall vip
    fgt_public_ip = google_compute_address.cluster_sip.address
    lb_probe_port = var.lb_probe_port
  }
}
