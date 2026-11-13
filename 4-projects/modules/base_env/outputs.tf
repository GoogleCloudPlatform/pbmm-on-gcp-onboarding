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

output "base_shared_vpc_project" {
  description = "Project sample base project."
  value       = try(module.base_shared_vpc_project[0].project_id, null)
}

output "base_shared_vpc_project_sa" {
  description = "Project sample base project SA."
  value       = try(module.base_shared_vpc_project[0].sa, null)
}

output "base_subnets_self_links" {
  value       = local.base_subnets_self_links
  description = "The self-links of subnets from base environment."
}

output "service_project_config" {
  description = "service_project_config"
  value       = var.service_project_config

}

output "peering_project_config" {
  description = "peering_project_config"
  value       = var.peering_project_config

}

output "float_project_config" {
  description = "float_project_config"
  value       = var.float_project_config

}

output "peering_project_enable_base" {
  description = "peering_project_enable_base"
  value = {
    all = ((try(var.peering_project_config != null &&
      contains(keys(var.peering_project_config), "project_type"), false) &&
      var.peering_project_config.project_type == "peering" &&
      contains(keys(var.peering_project_config), "base") &&
    try(var.peering_project_config.base != null, false)) ? 1 : 0)
    test1 = (var.peering_project_config != null)
    test2 = contains(keys(var.peering_project_config), "project_type")
    test3 = var.peering_project_config.project_type == "peering"
    test4 = contains(keys(var.peering_project_config), "base")
    test5 = var.peering_project_config.base != null
  }
}

output "peering_project_enable_restricted" {
  description = "peering_project_enable_restricted"
  value = {
    all = ((try(var.peering_project_config != null &&
      contains(keys(var.peering_project_config), "project_type"), false) &&
      var.peering_project_config.project_type == "peering" &&
      contains(keys(var.peering_project_config), "restricted") &&
    try(var.peering_project_config.restricted != null, false)) ? 1 : 0)
    test1 = (var.peering_project_config != null)
    test2 = contains(keys(var.peering_project_config), "project_type")
    test3 = var.peering_project_config.project_type == "peering"
    test4 = contains(keys(var.peering_project_config), "restricted")
    test5 = var.peering_project_config.restricted != null
  }
}

output "float_project_enable_base" {
  description = "float_project_config"
  value = {
    all = ((try(var.float_project_config != null &&
      contains(keys(var.float_project_config), "project_type"), false) &&
      var.float_project_config.project_type == "float" &&
      contains(keys(var.float_project_config), "base") &&
    try(var.float_project_config.base != null, false)) ? 1 : 0)

    test1 = (var.float_project_config != null)
    test2 = contains(keys(var.float_project_config), "project_type")
    test3 = var.float_project_config.project_type == "peering"
    test4 = contains(keys(var.float_project_config), "base")
    test5 = var.float_project_config.base != null
  }
}

output "float_project_enable_restricted" {
  description = "peering_project_enable_restricted"
  value = {
    all = ((try(var.float_project_config != null &&
      contains(keys(var.float_project_config), "project_type"), false) &&
      var.float_project_config.project_type == "float" &&
      contains(keys(var.float_project_config), "restricted") &&
    try(var.float_project_config.restricted != null, false)) ? 1 : 0)

    test1 = (var.float_project_config != null)
    test2 = contains(keys(var.float_project_config), "project_type")
    test3 = var.float_project_config.project_type == "peering"
    test4 = contains(keys(var.float_project_config), "restricted")
    test5 = var.float_project_config.restricted != null
  }
}


# Legacy upstream TEF v4 output compatibility for business_unit_1 / business_unit_2 roots
output "floating_project" {
  description = "Project sample floating project."
  value       = try(module.floating_project_base[0].project_id, null)
}

output "peering_project" {
  description = "Project sample peering project."
  value       = try(module.base_peering_project[0].project_id, null)
}

output "peering_network" {
  description = "Peering network resource."
  value       = try(module.base_peering_net[0].peering_network, null)
}

output "restricted_shared_vpc_project" {
  description = "Project sample restricted project."
  value       = try(module.restricted_shared_vpc_project[0].project_id, null)
}

output "restricted_shared_vpc_project_number" {
  description = "Project sample restricted project number."
  value       = try(module.restricted_shared_vpc_project[0].project_number, null)
}

output "restricted_subnets_self_links" {
  description = "The self-links of subnets from restricted environment."
  value       = try(local.restricted_subnets_self_links, null)
}

output "vpc_service_control_perimeter_name" {
  description = "The name of VPC Service Control Perimeter."
  value       = try(local.perimeter_name, null)
}

output "restricted_enabled_apis" {
  description = "Activated APIs in restricted project."
  value       = try(module.restricted_shared_vpc_project[0].enabled_apis, [])
}

output "access_context_manager_policy_id" {
  description = "Access Context Manager Policy ID."
  value       = try(local.access_context_manager_policy_id, null)
}

output "peering_complete" {
  description = "Output to be used as a module dependency."
  value       = try(module.base_peering_net[0].complete, null)
}

output "env_kms_project" {
  description = "Project sample KMS project."
  value       = try(data.terraform_remote_state.environments_env.outputs.env_kms_project_id, null)
}

output "keyring" {
  description = "Keyring resource."
  value       = null
}

output "keys" {
  description = "Keys map."
  value       = {}
}

output "bucket" {
  description = "CMEK bucket resource."
  value       = null
}

output "peering_subnetwork_self_link" {
  description = "Peering subnetwork self-link."
  value       = try(module.base_peering_net[0].peering_subnetwork_self_link, null)
}

output "iap_firewall_tags" {
  description = "IAP firewall tags."
  value       = []
}
