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

output "sl_base_subnets_by_srvprj_org" {
  description = "sl_base_subnets_by_srvprj_org from module"
  value       = module.prj_config.sl_base_subnets_by_srvprj
}
output "sl_restricted_subnets_by_srvprj_org" {
  description = "sl_base_subnets_by_srvprj_org from module"
  value       = module.prj_config.sl_restricted_subnets_by_srvprj
}
output "sl_base_subnets_by_srvprj" {
  description = "sl_base_subnets_by_srvprj_org masaged"
  value       = local.sl_base_subnets_by_srvprj
}
output "sl_restricted_subnets_by_srvprj" {
  description = "sl_base_subnets_by_srvprj_org massaged"
  value       = local.sl_restricted_subnets_by_srvprj
}
output "bu_config" {
  description = "bu_config"
  value       = local.bu_config
}
output "bu_config_debug" {
  description = "bu_config_debug"
  value       = local.bu_config_debug
}
output "flattened_bu_config_by_project" {
  description = "flattened_bu_config_by_project"
  value       = local.flattened_bu_config_by_project
}
output "debug_create_folders" {
  description = "debug_create_folders"
  value       = local.debug_create_folders
}
output "service_project_config" {
  description = "service_project_config"
  value       = { for k, v in module.env : k => v.service_project_config }
}
output "peering_project_config" {
  description = "peering_project_config"
  value       = { for k, v in module.env : k => v.peering_project_config }
}
output "float_project_config" {
  description = "float_project_config"
  value       = { for k, v in module.env : k => v.float_project_config }
}
output "peering_project_base_enable" {
  description = "peering_project_enable_base"
  value       = { for k, v in module.env : k => v.peering_project_enable_base }
}
output "peering_project_enable_restricted" {
  description = "peering_project_config"
  value       = { for k, v in module.env : k => v.peering_project_enable_restricted }
}
output "float_project_enable_base" {
  description = "float_project_enable_base"
  value       = { for k, v in module.env : k => v.float_project_enable_base }
}
output "float_project_enable_restricted" {
  description = "float_project_enable_base"
  value       = { for k, v in module.env : k => v.float_project_enable_restricted }
}
/**************************************/
