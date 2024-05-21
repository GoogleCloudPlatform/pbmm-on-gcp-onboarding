/**
 * Copyright 2021 Google LLC
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

/******* MRo: disable for now
output "base_shared_vpc_project" {
  description = "Project sample base project."
  value       = module.env.base_shared_vpc_project
}

output "base_shared_vpc_project_sa" {
  description = "Project sample base project SA."
  value       = module.env.base_shared_vpc_project_sa
}

output "base_subnets_self_links" {
  value       = module.env.base_subnets_self_links
  description = "The self-links of subnets from base environment."
}

output "floating_project" {
  description = "Project sample floating project."
  value       = module.env.floating_project
}

output "peering_project" {
  description = "Project sample peering project id."
  value       = module.env.peering_project
}

output "peering_network" {
  description = "Peer network peering resource."
  value       = module.env.peering_network
}

output "restricted_shared_vpc_project" {
  description = "Project sample restricted project id."
  value       = module.env.restricted_shared_vpc_project
}

output "restricted_shared_vpc_project_number" {
  description = "Project sample restricted project."
  value       = module.env.restricted_shared_vpc_project_number
}

output "restricted_subnets_self_links" {
  value       = module.env.restricted_subnets_self_links
  description = "The self-links of subnets from restricted environment."
}

output "vpc_service_control_perimeter_name" {
  description = "VPC Service Control name."
  value       = module.env.vpc_service_control_perimeter_name
}

output "restricted_enabled_apis" {
  description = "Activated APIs."
  value       = module.env.restricted_enabled_apis
}

output "access_context_manager_policy_id" {
  description = "Access Context Manager Policy ID."
  value       = module.env.access_context_manager_policy_id
}

output "peering_complete" {
  description = "Output to be used as a module dependency."
  value       = module.env.peering_complete
}

output "env_kms_project" {
  description = "Project sample for KMS usage project ID."
  value       = module.env.env_kms_project
}

output "keyring" {
  description = "The name of the keyring."
  value       = module.env.keyring
}

output "keys" {
  description = "List of created key names."
  value       = module.env.keys
}

output "bucket" {
  description = "The created storage bucket."
  value       = module.env.bucket
}

output "peering_subnetwork_self_link" {
  description = "The subnetwork self link of the peering network."
  value       = module.env.peering_subnetwork_self_link
}

output "iap_firewall_tags" {
  description = "The security tags created for IAP (SSH and RDP) firewall rules and to be used on the VM created on step 5-app-infra on the peering network project."
  value       = module.env.iap_firewall_tags
}
********/
/************ MRo: debug **************/
output "sl_base_subnets_by_srvprj_org" {
  description = "sl_base_subnets_by_srvprj_org from module"
  value = module.prj_config.sl_base_subnets_by_srvprj
}

output "sl_restricted_subnets_by_srvprj_org" {
  description = "sl_base_subnets_by_srvprj_org from module"
  value = module.prj_config.sl_restricted_subnets_by_srvprj
}

output "sl_base_subnets_by_srvprj" {
  description = "sl_base_subnets_by_srvprj_org masaged"
  value = local.sl_base_subnets_by_srvprj
}

output "sl_restricted_subnets_by_srvprj" {
  description = "sl_base_subnets_by_srvprj_org massaged"
  value = local.sl_restricted_subnets_by_srvprj
}

output "bu_config" {
  description = "bu_config"
  value = local.bu_config
}

output "bu_config_debug" {
  description = "bu_config_debug"
  value = local.bu_config_debug
}

output "flattened_bu_config_by_project" {
  description = "flattened_bu_config_by_project"
  value = local.flattened_bu_config_by_project

}
output "debug_create_folders" {
  description = "debug_create_folders"
  value = local.debug_create_folders

}
output "service_project_config" {
  description = "service_project_config"
  value = { for k,v in module.env : k => v.service_project_config}
}
output "peering_project_config" {
  description = "peering_project_config"
  value = { for k,v in module.env : k => v.peering_project_config}
}
output "float_project_config" {
  description = "float_project_config"
  value = { for k,v in module.env : k => v.float_project_config}
}
output "peering_project_base_enable" {
  description = "peering_project_enable_base"
  value = { for k,v in module.env : k => v.peering_project_enable_base}
}
output "peering_project_enable_restricted" {
  description = "peering_project_config"
  value = { for k,v in module.env : k => v.peering_project_enable_restricted}
}
output "float_project_enable_base" {
  description = "float_project_enable_base"
  value = { for k,v in module.env : k => v.float_project_enable_base}
}
output "float_project_enable_restricted" {
  description = "float_project_enable_base"
  value = { for k,v in module.env : k => v.float_project_enable_restricted}
}
/**************************************/
