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

/*********************
 Restricted Outputs
*********************/

output "restricted_host_project_id" {
  value       = local.restricted_project_id
  description = "The restricted host project ID"
}

output "restricted_network_name" {
  value       = one(module.restricted_shared_vpc).network_name
  description = "The name of the VPC being created"
}

output "restricted_network_self_link" {
  value       = one(module.restricted_shared_vpc).network_self_link
  description = "The URI of the VPC being created"
}

output "restricted_subnets_names" {
//  value       = module.restricted_shared_vpc.subnets_names
  value = local.filtered_restricted_subnets_names
  description = "The names of the subnets being created"
}

output "restricted_subnets_ips" {
//  value       = module.restricted_shared_vpc.subnets_ips
  value = local.filtered_restricted_subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "restricted_subnets_self_links" {
  value       = one(module.restricted_shared_vpc).subnets_self_links
  description = "The self-links of subnets being created"
}

output "restricted_subnets_secondary_ranges" {
  value       = one(module.restricted_shared_vpc).subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "restricted_access_level_name" {
  value       = one(module.restricted_shared_vpc).access_level_name
  description = "Access context manager access level name"
}

output "restricted_service_perimeter_name" {
  value       = one(module.restricted_shared_vpc).service_perimeter_name
  description = "Access context manager service perimeter name"
}

/******************************************
 Private Outputs
*****************************************/

output "base_host_project_id" {
  value       = local.base_project_id
  description = "The base host project ID"
}

output "base_network_name" {
  value       = one(module.base_shared_vpc).network_name
  description = "The name of the VPC being created"
}

output "base_network_self_link" {
  value       = one(module.base_shared_vpc).network_self_link
  description = "The URI of the VPC being created"
}

output "base_subnets_names" {
//  value       = module.base_shared_vpc.subnets_names
  value = local.filtered_base_subnets_names
  description = "The names of the subnets being created"
}

output "base_subnets_ips" {
//  value       = module.base_shared_vpc.subnets_ips
  value = local.filtered_base_subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "base_subnets_self_links" {
  value       = one(module.base_shared_vpc).subnets_self_links
  description = "The self-links of subnets being created"
}

output "base_subnets_secondary_ranges" {
  value       = one(module.base_shared_vpc).subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}
// MRo: added calculated selflink vars
output "sl_base_subnets_split" {
   description  = "sl_base_subnets_split"
   value        = local.sl_base_subnets_split
}

output "sl_restricted_subnets_split" {
   description  = "sl_restricted_subnets_split"
   value        = local.sl_restricted_subnets_split
}

output "sl_base_subnets_by_srvprj" {
   description  = "sl_base_subnets_by_srvprj"
   value        = local.sl_base_subnets_by_srvprj
}

output "sl_restricted_subnets_by_srvprj" {
   description  = "sl_restricted_subnets_by_srvprj"
   value        = local.sl_restricted_subnets_by_srvprj
}

output "fake_output" {
  value = ""
}

output "fake_output1" {
  value = null
}

output "fake_output2" {
  value = "testing fake value"
}