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

output "port_to_network_map" {
  value       = { for port, value in var.network_ports : port => value.subnetwork }
  description = "A map that shows which port is connected to which subnet."
}

output "external_route" {
  value       = google_compute_route.external_default.name
  description = "The name of the route table associated to external(public) network."
}
output "internal_route" {
  value       = google_compute_route.internal_default.name
  description = "The name of the route table associated to internal(private) network."
}

output "external_nlb_public_ip" {
  value       = google_compute_address.cluster_sip.address
  description = "The public IP address of the external NLB for NorthSouth traffic"
}

output "external_ilbnh_public_ip" {
  value       = google_compute_address.external_ilbnh_address.address
  description = "The private IP address of the iLBnH for East-West traffic from external subnet."
}

output "internal_ilbnh_public_ip" {
  value       = google_compute_address.internal_ilbnh_address.address
  description = "The private IP address of the iLBnH for internal East-West traffic."
}

output "fortigate_ha_active_mgmt_ip" {
  value       = google_compute_address.active_instance_mgmt_sip
  description = "The public IP address used for active instance management."
}

output "fortigate_ha_passive_mgmt_ip" {
  value       = google_compute_address.passive_instance_mgmt_sip
  description = "The public IP address used for passive instance management."
}

output "fortigate_admin_username" {
  value       = "admin"
  description = "The adminstrator login name for Fortigate NGFW VMs"
}

output "fortigate_admin_password" {
  value       = random_password.fgt_ha_password.result
  sensitive   = true
  description = "The initial adminstrator login password for Fortigate NGFW VMs"
}
