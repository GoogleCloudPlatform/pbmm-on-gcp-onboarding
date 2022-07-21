/**
 * Copyright 2022 Google LLC
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
    fgt_vm_name         = module.vm_name[each.key].result
    fgt_ha_password     = random_password.fgt_ha_password.result
    fortigate_trusthost = "0.0.0.0/0"
    fgt_ha_priority     = local.instances[each.key].priority
    fgt_ha_ip           = local.instances[each.key].port3_ip
    fgt_ha_netmask      = cidrnetmask(data.google_compute_subnetwork.subnetworks[var.ha_port].ip_cidr_range)
    fgt_ha_port         = var.ha_port
    fgt_public_ip       = local.instances[each.key].public_ip
    fgt_public_netmask  = "255.255.255.255"
    fgt_public_port     = var.public_port
  }
}

data "template_file" "replication" {
  for_each = local.instances
  template = file("${path.module}/templates/replication.tpl")
  vars = {
    fgt_ha_peerip   = local.instances[each.key].peer_ip
    fgt_ha_netmask  = cidrnetmask(data.google_compute_subnetwork.subnetworks[var.ha_port].ip_cidr_range)
    fgt_ha_priority = local.instances[each.key].priority
    fgt_ha_port     = var.ha_port
  }
}