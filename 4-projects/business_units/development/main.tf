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

locals {
  env              = "development"
  bu_config        = module.prj_config.bu_config
  // MRo: must massage them a bit to have for each selflink a map with the project IFDs as keys
  sl_base_subnets_by_srvprj = { for one_merged_sl_k, one_merged_sl_v in {
    for one_sl_k, one_sl_v in module.prj_config.sl_base_subnets_by_srvprj: one_sl_k =>  merge(one_sl_v...)
  } : one_merged_sl_k => one_merged_sl_v if length(keys(one_merged_sl_v)) > 0 }

  sl_restricted_subnets_by_srvprj = { for one_merged_sl_k, one_merged_sl_v in  {
     for one_sl_k, one_sl_v in module.prj_config.sl_restricted_subnets_by_srvprj: one_sl_k =>  merge(one_sl_v...)
  } : one_merged_sl_k => one_merged_sl_v if length(keys(one_merged_sl_v)) > 0 }

  billing_account  = module.prj_config.billing_account
  // hack for nested for_each enumerating service projects
  flattened_bu_config_by_project  = distinct(flatten([
    for one_bu_config in local.bu_config : concat([
      for one_project in one_bu_config.base_projects : {
        bu_config  = one_bu_config
        prj_config = one_project
        type = "base"
      }
    ],[for one_project in one_bu_config.restricted_projects : {
        bu_config  = one_bu_config
        prj_config = one_project
        type = "restricted"
      }
    ])
  ]))
/************ MRo: debug **************/
bu_config_debug = [for entry in local.flattened_bu_config_by_project : {
  service_project_config       = {
    base = ( entry.bu_config.base_enabled  &&  entry.type == "base" &&  entry.prj_config.type == "service" ? {
      ip_ranges_by_region      = entry.prj_config.ip_ranges
      service_project_id       = entry.prj_config.id
      service_project_app      = entry.prj_config.app
      srv_subnet_selflinks     = [ for one_subnet_self_link, one_sl_projects in local.sl_base_subnets_by_srvprj:
                                     one_subnet_self_link  if (contains(keys(one_sl_projects), entry.prj_config.id)) &&
                                     try(one_sl_projects[entry.prj_config.id].srv_project_mode == "service",false)  ]
    } : null)
    restricted = (entry.bu_config.restricted_enabled  &&  entry.type == "restricted" &&  entry.prj_config.type == "service" ? {
      ip_ranges_by_region      = entry.prj_config.ip_ranges
      service_project_id       = entry.prj_config.id
      service_project_app      = entry.prj_config.app
      srv_subnet_selflinks     = [ for one_subnet_self_link, one_sl_projects in local.sl_restricted_subnets_by_srvprj:
                                     one_subnet_self_link  if (contains(keys(one_sl_projects), entry.prj_config.id)) &&
                                     try(one_sl_projects[entry.prj_config.id].srv_project_mode == "service",false)  ]
    } : null)
  }}  ]
  // MRo: for debug, 2'nd bu2 folder not created
  debug_create_folders =  {for entry in local.flattened_bu_config_by_project : entry.prj_config.id =>  {
        folder_id = module.bu_folder[entry.bu_config.business_code].folder_id
        business_code = entry.bu_config.business_code
      }
  }
/**************************************/
}

module "prj_config" {
  source = "../../modules/prj_config"
  env  = local.env
  remote_state_bucket  = var.remote_state_bucket
  config_file = abspath("${path.module}/../../prj_config.yaml")
}

/************* MRo: debug
// this one creates fine both folders
module "dbg_folder" {
  source = "../../modules/bu_folder"
  for_each   = { for one_bu_config in local.bu_config: one_bu_config.business_code => one_bu_config }
  //for_each   =  toset(local.bu_config)
  env        = local.env
  remote_state_bucket  = var.remote_state_bucket
  business_code = "dbg-${each.value.business_code}"
  business_unit = "dbg-${each.value.business_unit}"
  folder_prefix = each.value.folder_prefix
}
************/

module "bu_folder" {
  source = "../../modules/bu_folder"
  for_each   = { for one_bu_config in local.bu_config: one_bu_config.business_code => one_bu_config }
  //for_each   =  toset(local.bu_config)
  env        = local.env
  remote_state_bucket  = var.remote_state_bucket
  business_code = each.value.business_code
  business_unit = each.value.business_unit
  folder_prefix = each.value.folder_prefix
}

module "env" {
  source = "../../modules/base_env"
  for_each                     = {for key,entry in local.flattened_bu_config_by_project : entry.prj_config.id => entry}
  env                          = local.env
  peering_module_depends_on    = var.peering_module_depends_on
  remote_state_bucket          = var.remote_state_bucket
  business_code                = each.value.bu_config.business_code
  business_unit                = each.value.bu_config.business_unit
  location_kms                 = each.value.bu_config.location_kms
  location_gcs                 = each.value.bu_config.location_gcs
  tfc_org_name                 = each.value.bu_config.tfc_org_name
  peering_iap_fw_rules_enabled = each.value.bu_config.peering_iap_fw_rules_enabled
  firewall_enable_logging      = each.value.bu_config.firewall_logging_enabled
  optional_fw_rules_enabled    = each.value.bu_config.optional_fw_rules_enabled
  windows_activation_enabled   = each.value.bu_config.windows_activation_enabled
  keyring_name                 = each.value.bu_config.key_ring_name
  key_name                     = each.value.bu_config.key_name
  gcs_bucket_prefix            = each.value.bu_config.bucket_prefix
  folder_prefix                = each.value.bu_config.folder_prefix
  key_rotation_period          = each.value.bu_config.key_rotation_period
  service_project_config       = {
    base = ( each.value.bu_config.base_enabled  &&  each.value.type == "base" &&  each.value.prj_config.type == "service" ? {
      bu_config                = each.value.bu_config
      region_config            = each.value.bu_config.region_config
//      ip_ranges_by_region      = each.value.prj_config.ip_ranges
// MRo: TODO cleanup and more generic, this is a hack
      ip_ranges_by_region      = merge((contains(keys(each.value.prj_config.ip_ranges),"region1") &&
                                        try(each.value.bu_config.region_config.region1.enabled,true) ? {
                                    (each.value.bu_config.region_config.region1.name) = each.value.prj_config.ip_ranges.region1
                                 } : {}), contains(keys(each.value.prj_config.ip_ranges),"region2") &&
                                    try(each.value.bu_config.region_config.region2.enabled,false) ? {
                                    (each.value.bu_config.region_config.region2.name) = each.value.prj_config.ip_ranges.region2
                                 } : {})
      project_id               = each.value.prj_config.id
      project_app              = each.value.prj_config.app
      srv_subnet_selflinks     = [ for one_subnet_self_link, one_sl_projects in local.sl_base_subnets_by_srvprj:
                                     one_subnet_self_link  if (contains(keys(one_sl_projects), each.value.prj_config.id)) &&
                                     try(one_sl_projects[each.value.prj_config.id].srv_project_mode == "service",false)  ]
    } : null)
    restricted = (each.value.bu_config.restricted_enabled  &&  each.value.type == "restricted" &&  each.value.prj_config.type == "service" ? {
      bu_config                = each.value.bu_config
      region_config            = each.value.bu_config.region_config
//      ip_ranges_by_region      = each.value.prj_config.ip_ranges
      ip_ranges_by_region      = merge((contains(keys(each.value.prj_config.ip_ranges),"region1") &&
                                        try(each.value.bu_config.region_config.region1.enabled,true) ? {
                                    (each.value.bu_config.region_config.region1.name) = each.value.prj_config.ip_ranges.region1
                                 } : {}), contains(keys(each.value.prj_config.ip_ranges),"region2") &&
                                    try(each.value.bu_config.region_config.region2.enabled,false) ? {
                                    (each.value.bu_config.region_config.region2.name) = each.value.prj_config.ip_ranges.region2
                                 } : {})
      project_id               = each.value.prj_config.id
      project_app              = each.value.prj_config.app
      srv_subnet_selflinks     = [ for one_subnet_self_link, one_sl_projects in local.sl_restricted_subnets_by_srvprj:
                                     one_subnet_self_link  if (contains(keys(one_sl_projects), each.value.prj_config.id)) &&
                                     try(one_sl_projects[each.value.prj_config.id].srv_project_mode == "service",false)  ]
    } : null)
    // MRo: above try because Terraform logical operators don't short-circuit https://github.com/hashicorp/terraform/issues/24128
    billing_code               = each.value.bu_config.billing_code
    primary_contact            = each.value.bu_config.primary_contact
    secondary_contact          = each.value.bu_config.secondary_contact
    restricted_vpc_scp_enabled = each.value.bu_config.restricted_vpc_scp_enabled
    project_type               = "service"
    // folder_id                  = module.bu_folder.folder_id
    //folder_id = one(values({ for k,one_bu_folder in module.bu_folder : k => one_bu_folder.folder_id
    //                  if one_bu_folder.business_code == each.value.bu_config.business_code &&
    //                     one_bu_folder.business_unit == each.value.bu_config.business_unit }))
    folder_id                  = module.bu_folder[each.value.bu_config.business_code].folder_id
    // redundant?
    // depends_on                 = [module.bu_folder]

  }
  peering_project_config       = {
    base = ( each.value.bu_config.base_enabled  &&  each.value.type == "base" &&  each.value.prj_config.type == "peering" ? {
      bu_config                = each.value.bu_config
      region_config            = each.value.bu_config.region_config
//      ip_ranges_by_region      = each.value.prj_config.ip_ranges
      ip_ranges_by_region      = merge((contains(keys(each.value.prj_config.ip_ranges),"region1") &&
                                        try(each.value.bu_config.region_config.region1.enabled,true) ? {
                                    (each.value.bu_config.region_config.region1.name) = each.value.prj_config.ip_ranges.region1
                                 } : {}), contains(keys(each.value.prj_config.ip_ranges),"region2") &&
                                    try(each.value.bu_config.region_config.region2.enabled,false) ? {
                                    (each.value.bu_config.region_config.region2.name) = each.value.prj_config.ip_ranges.region2
                                 } : {})
      project_id               = each.value.prj_config.id
      project_app              = each.value.prj_config.app
    } : null)
    restricted = (each.value.bu_config.restricted_enabled  &&  each.value.type == "restricted" &&  each.value.prj_config.type == "peering" ? {
      bu_config                = each.value.bu_config
      region_config            = each.value.bu_config.region_config
//      ip_ranges_by_region      = each.value.prj_config.ip_ranges
      ip_ranges_by_region      = merge((contains(keys(each.value.prj_config.ip_ranges),"region1") &&
                                        try(each.value.bu_config.region_config.region1.enabled,true) ? {
                                    (each.value.bu_config.region_config.region1.name) = each.value.prj_config.ip_ranges.region1
                                 } : {}), contains(keys(each.value.prj_config.ip_ranges),"region2") &&
                                    try(each.value.bu_config.region_config.region2.enabled,false) ? {
                                    (each.value.bu_config.region_config.region2.name) = each.value.prj_config.ip_ranges.region2
                                 } : {})
      project_id               = each.value.prj_config.id
      project_app              = each.value.prj_config.app
    } : null)
    // MRo: above try because Terraform logical operators don't short-circuit https://github.com/hashicorp/terraform/issues/24128
    billing_code               = each.value.bu_config.billing_code
    primary_contact            = each.value.bu_config.primary_contact
    secondary_contact          = each.value.bu_config.secondary_contact
    restricted_vpc_scp_enabled = each.value.bu_config.restricted_vpc_scp_enabled
    project_type               = "peering"
    //folder_id = one(values({ for k,one_bu_folder in module.bu_folder : k => one_bu_folder.folder_id
    //                  if one_bu_folder.business_code == each.value.bu_config.business_code &&
    //                     one_bu_folder.business_unit == each.value.bu_config.business_unit }))
    folder_id                  = module.bu_folder[each.value.bu_config.business_code].folder_id
  }

  float_project_config       = {
    base = ( each.value.bu_config.base_enabled  &&  each.value.type == "base" &&  each.value.prj_config.type == "float" ? {
      bu_config                = each.value.bu_config
      region_config            = each.value.bu_config.region_config
//      ip_ranges_by_region      = each.value.prj_config.ip_ranges
      ip_ranges_by_region      = merge((contains(keys(each.value.prj_config.ip_ranges),"region1") &&
                                        try(each.value.bu_config.region_config.region1.enabled,true) ? {
                                    (each.value.bu_config.region_config.region1.name) = each.value.prj_config.ip_ranges.region1
                                 } : {}), contains(keys(each.value.prj_config.ip_ranges),"region2") &&
                                    try(each.value.bu_config.region_config.region2.enabled,false) ? {
                                    (each.value.bu_config.region_config.region2.name) = each.value.prj_config.ip_ranges.region2
                                 } : {})
      project_id               = each.value.prj_config.id
      project_app              = each.value.prj_config.app
    } : null)
    restricted = (each.value.bu_config.restricted_enabled  &&  each.value.type == "restricted" &&  each.value.prj_config.type == "float" ? {
      bu_config                = each.value.bu_config
      region_config            = each.value.bu_config.region_config
//      ip_ranges_by_region      = each.value.prj_config.ip_ranges
      ip_ranges_by_region      = merge((contains(keys(each.value.prj_config.ip_ranges),"region1") &&
                                        try(each.value.bu_config.region_config.region1.enabled,true) ? {
                                    (each.value.bu_config.region_config.region1.name) = each.value.prj_config.ip_ranges.region1
                                 } : {}), contains(keys(each.value.prj_config.ip_ranges),"region2") &&
                                    try(each.value.bu_config.region_config.region2.enabled,false) ? {
                                    (each.value.bu_config.region_config.region2.name) = each.value.prj_config.ip_ranges.region2
                                 } : {})
      project_id               = each.value.prj_config.id
      project_app              = each.value.prj_config.app
    } : null)
    // MRo: above try because Terraform logical operators don't short-circuit https://github.com/hashicorp/terraform/issues/24128
    billing_code               = each.value.bu_config.billing_code
    primary_contact            = each.value.bu_config.primary_contact
    secondary_contact          = each.value.bu_config.secondary_contact
    restricted_vpc_scp_enabled = each.value.bu_config.restricted_vpc_scp_enabled
    project_type               = "float"
//    folder_id = one(values({ for k,one_bu_folder in module.bu_folder : k => one_bu_folder.folder_id
//                      if one_bu_folder.business_code == each.value.bu_config.business_code &&
//                         one_bu_folder.business_unit == each.value.bu_config.business_unit }))
    folder_id                  = module.bu_folder[each.value.bu_config.business_code].folder_id
  }
  //subnet_region                = var.instance_region
  // MRo: TODO move to config, no hardcoding
  //subnet_ip_range              = "10.3.128.0/21"
}
