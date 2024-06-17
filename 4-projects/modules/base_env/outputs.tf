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
  value       = try(module.base_shared_vpc_project[0].project_id,null)
}

output "base_shared_vpc_project_sa" {
  description = "Project sample base project SA."
  value       = try(module.base_shared_vpc_project[0].sa,null)
}

output "base_subnets_self_links" {
  value       = local.base_subnets_self_links
  description = "The self-links of subnets from base environment."
}

/******** MRo: debug ***********/
output "service_project_config" {
  description = "service_project_config"
  value = var.service_project_config

}

output "peering_project_config" {
  description = "peering_project_config"
  value = var.peering_project_config

}

output "float_project_config" {
  description = "float_project_config"
  value = var.float_project_config

}

output "peering_project_enable_base" {
  description = "peering_project_enable_base"
  value = {
    all =  ((try(var.peering_project_config != null &&
          contains(keys(var.peering_project_config),"project_type"),false) &&
          var.peering_project_config.project_type == "peering" &&
          contains(keys(var.peering_project_config), "base") &&
          try(var.peering_project_config.base != null, false)) ? 1:0)
    test1 = (var.peering_project_config != null)
    test2 = contains(keys(var.peering_project_config),"project_type")
    test3 = var.peering_project_config.project_type == "peering"
    test4 = contains(keys(var.peering_project_config), "base")
    test5 = var.peering_project_config.base != null
  }
}

output "peering_project_enable_restricted" {
  description = "peering_project_enable_restricted"
  value = {
    all =  ((try(var.peering_project_config != null &&
           contains(keys(var.peering_project_config),"project_type"),false) &&
           var.peering_project_config.project_type == "peering" &&
           contains(keys(var.peering_project_config), "restricted") &&
           try(var.peering_project_config.restricted != null, false)) ? 1:0)
    test1 = (var.peering_project_config != null)
    test2 = contains(keys(var.peering_project_config),"project_type")
    test3 = var.peering_project_config.project_type == "peering"
    test4 = contains(keys(var.peering_project_config), "restricted")
    test5 = var.peering_project_config.restricted != null
  }
}

output "float_project_enable_base" {
  description = "float_project_config"
  value = {
    all = ((try(var.float_project_config != null &&
           contains(keys(var.float_project_config),"project_type"),false) &&
           var.float_project_config.project_type == "float" &&
           contains(keys(var.float_project_config), "base") &&
           try(var.float_project_config.base != null, false)) ? 1:0)

    test1 = (var.float_project_config != null)
    test2 = contains(keys(var.float_project_config),"project_type")
    test3 = var.float_project_config.project_type == "peering"
    test4 = contains(keys(var.float_project_config), "base")
    test5 = var.float_project_config.base != null
  }
}

output "float_project_enable_restricted" {
  description = "peering_project_enable_restricted"
  value = {
    all = ((try(var.float_project_config != null &&
           contains(keys(var.float_project_config),"project_type"),false) &&
           var.float_project_config.project_type == "float" &&
           contains(keys(var.float_project_config), "restricted") &&
           try(var.float_project_config.restricted != null, false)) ? 1:0)

    test1 = (var.float_project_config != null)
    test2 = contains(keys(var.float_project_config),"project_type")
    test3 = var.float_project_config.project_type == "peering"
    test4 = contains(keys(var.float_project_config), "restricted")
    test5 = var.float_project_config.restricted != null
  }
}



/******** MRo: disable for now
output "floating_project" {
  description = "Project sample floating project."
  value       = module.floating_project.project_id
}

output "peering_project" {
  description = "Project sample peering project id."
  value       = module.peering_project.project_id
}

output "peering_network" {
  description = "Peer network peering resource."
  value       = module.peering.peer_network_peering
}

output "restricted_shared_vpc_project" {
  description = "Project sample restricted project id."
//value       = module.restricted_shared_vpc_project.project_id
  value = [for one_restricted_shared_vpc_project in module.restricted_shared_vpc_project: one_restricted_shared_vpc_project.project_sa]

}

output "restricted_shared_vpc_project_number" {
  description = "Project sample restricted project."
//value       = module.restricted_shared_vpc_project.project_number
  value = [for one_restricted_shared_vpc_project in module.restricted_shared_vpc_project: one_restricted_shared_vpc_project.project_number]
}

output "restricted_subnets_self_links" {
  value       = local.restricted_subnets_self_links
  description = "The self-links of subnets from restricted environment."
}

output "vpc_service_control_perimeter_name" {
  description = "VPC Service Control name."
  value       = local.perimeter_name
}

output "access_context_manager_policy_id" {
  description = "Access Context Manager Policy ID."
  value       = local.access_context_manager_policy_id
}

output "restricted_enabled_apis" {
  description = "Activated APIs."
//value       = module.restricted_shared_vpc_project.enabled_apis
  value = [for one_restricted_shared_vpc_project in module.restricted_shared_vpc_project: one_restricted_shared_vpc_project.enabled_apis]

}

output "peering_complete" {
  description = "Output to be used as a module dependency."
  value       = module.peering.complete
}

output "env_kms_project" {
  description = "Project sample for KMS usage project ID."
  value       = module.env_kms_project.project_id
}

output "keyring" {
  description = "The name of the keyring."
  value       = module.kms.keyring
}

output "keys" {
  description = "List of created key names."
  value       = keys(module.kms.keys)
}

output "bucket" {
  description = "The created storage bucket."
  value       = module.gcs_buckets.bucket
}

output "peering_subnetwork_self_link" {
  description = "The subnetwork self link of the peering network."
  value       = var.peering_iap_fw_rules_enabled ? module.peering_network.subnets_self_links[0] : ""
}

output "iap_firewall_tags" {
  description = "The security tags created for IAP (SSH and RDP) firewall rules and to be used on the VM created on step 5-app-infra on the peering network project."
  value = var.peering_iap_fw_rules_enabled ? {
    "tagKeys/${google_tags_tag_key.firewall_tag_key_ssh[0].name}" = "tagValues/${google_tags_tag_value.firewall_tag_value_ssh[0].name}"
    "tagKeys/${google_tags_tag_key.firewall_tag_key_rdp[0].name}" = "tagValues/${google_tags_tag_value.firewall_tag_value_rdp[0].name}"
  } : {}
}
********/