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

output "access_context_manager_policy_id" {
  description = "Access Context Manager Policy ID."
  value       = var.access_context_manager_policy_id
}

/*********************
 Restricted Outputs
*********************/

output "restricted_host_project_id" {
  value       = try(module.base_env.restricted_host_project_id,null)
  description = "The restricted host project ID"
}

output "restricted_network_name" {
  value       = try(module.base_env.restricted_network_name,null)
  description = "The name of the VPC being created"
}

output "restricted_network_self_link" {
  value       = try(module.base_env.restricted_network_self_link,null)
  description = "The URI of the VPC being created"
}

output "restricted_subnets_names" {
  value       = try(module.base_env.restricted_subnets_names,null)
  description = "The names of the subnets being created"
}

output "restricted_subnets_ips" {
  value       = try(module.base_env.restricted_subnets_ips,null)
  description = "The IPs and CIDRs of the subnets being created"
}

output "restricted_subnets_self_links" {
  value       = try(module.base_env.restricted_subnets_self_links,null)
  description = "The self-links of subnets being created"
}

output "restricted_subnets_secondary_ranges" {
  value       = try(module.base_env.restricted_subnets_secondary_ranges,null)
  description = "The secondary ranges associated with these subnets"
}

output "restricted_access_level_name" {
  value       = try(module.base_env.restricted_access_level_name,null)
  description = "Access context manager access level name"
}

output "restricted_service_perimeter_name" {
  value       = try(module.base_env.restricted_service_perimeter_name,null)
  description = "Access context manager service perimeter name"
}

/******************************************
 Private Outputs
*****************************************/

output "base_host_project_id" {
  value       = module.base_env.base_host_project_id
  description = "The base host project ID"
}

output "base_network_name" {
  value       = module.base_env.base_network_name
  description = "The name of the VPC being created"
}

output "base_network_self_link" {
  value       = module.base_env.base_network_self_link
  description = "The URI of the VPC being created"
}

output "base_subnets_names" {
  value       = module.base_env.base_subnets_names
  description = "The names of the subnets being created"
}

output "base_subnets_ips" {
  value       = module.base_env.base_subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "base_subnets_self_links" {
  value       = module.base_env.base_subnets_self_links
  description = "The self-links of subnets being created"
}

output "base_subnets_secondary_ranges" {
  value       = module.base_env.base_subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

// MRo: added calculated selflink vars
output "sl_base_subnets_split" {
   description  = "sl_base_subnets_split"
   value        = module.base_env.sl_base_subnets_split
}

output "sl_restricted_subnets_split" {
   description  = "sl_restricted_subnets_split"
   value        = try(module.base_env.sl_restricted_subnets_split,null)
}

output "sl_base_subnets_by_srvprj" {
   description  = "sl_base_subnets_by_srvprj"
   value        = try(module.base_env.sl_base_subnets_by_srvprj,null)
}

output "sl_restricted_subnets_by_srvprj" {
   description  = "sl_restricted_subnets_by_srvprj"
   value        = try(module.base_env.sl_restricted_subnets_by_srvprj,null)
}
