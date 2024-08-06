/*********
 * Copyleft none
 ********/

locals {
  // MRo: these will be passed downstream
  all_config       = yamldecode(file("${var.config_file}"))
  sl_base_subnets_by_srvprj         = data.terraform_remote_state.network_env.outputs.sl_base_subnets_by_srvprj
  sl_restricted_subnets_by_srvprj   = try(data.terraform_remote_state.network_env.outputs.sl_restricted_subnets_by_srvprj, {})

  billing_account                   = data.terraform_remote_state.bootstrap.outputs.common_config.billing_account

  // MRo: TODO - what to specify when values used to label projects not specified
  bu_config   = [ for one_business_unit in local.all_config.business_units:
     {
        region_config                 = local.all_config.regions
        business_code                 = one_business_unit.business_code
        business_unit                 = one_business_unit.business_unit
        location_kms                  = try(one_business_unit.location_kms,"ca")
        location_gcs                  = try(one_business_unit.location_gcs,"ca")
        tfc_org_name                  = try(one_business_unit.tfc_org_name,"")
        bucket_prefix                 = try(one_business_unit.gcs_bucket_prefix,"bkt")
        folder_prefix                 = try(one_business_unit.folder_prefix,"fldr")
        primary_contact               = try(one_business_unit.primary_contact,"none@no.ne")
        secondary_contact             = try(one_business_unit.secondary_contact,"none@no.ne")
        // by env
        env_code                      = one_business_unit["${var.env}"].env_code
        billing_code                  = try(one_business_unit["${var.env}"].billing_code,"none")
        is_enabled                   = try(one_business_unit["${var.env}"].env_enabled, false)
        windows_activation_enabled    = try(one_business_unit["${var.env}"].windows_activation_enabled,false)
        firewall_logging_enabled      = try(one_business_unit["${var.env}"].firewall_logging_enabled,false)
        optional_fw_rules_enabled     = try(one_business_unit["${var.env}"].optional_fw_rules_enabled,false)
        vpc_flow_logs_enabled         = try(one_business_unit["${var.env}"].vpc_flow_logs_enabled,false)
        peering_iap_fw_rules_enabled  = try(one_business_unit["${var.env}"].peering_iap_fw_rules_enabled,false)
        key_ring_name                 = try(one_business_unit["${var.env}"].key_ring_name,"simple-keyring")
        key_name                      = try(one_business_unit["${var.env}"].key_ring_name,"simple-keyname")
        key_rotation_period           = try(one_business_unit["${var.env}"].key_rotation_period,"7776000s")
        // by sub-env (base,restricted)
        base_enabled                  = try(one_business_unit["${var.env}"].base.enabled,false)
        base_ip_ranges                = try(one_business_unit["${var.env}"].base.ip_ranges,{})
        restricted_enabled            = try(one_business_unit["${var.env}"].restricted.enabled,false)
        restricted_ip_ranges          = try(one_business_unit["${var.env}"].restricted.ip_ranges,{})
        base_projects                 = try(one_business_unit["${var.env}"].base.projects,[])
        restricted_projects           = try(one_business_unit["${var.env}"].restricted.projects,[])
        restricted_vpc_scp_enabled    = try(one_business_unit["${var.env}"].restricted.vpc_scp,false)
     } if (contains(keys(one_business_unit),"${var.env}")  &&
           contains(keys(one_business_unit),"business_unit") &&
           contains(keys(one_business_unit),"business_code") )
  ]
  // all project IDs must be distinct across BUs, envs, etc
  all_project_ids = flatten([ for one_bu in local.all_config.business_units: [
    for one_bu_config_k in keys(one_bu):
        (try(contains(keys(one_bu[one_bu_config_k]),"base"), false) ?
        (try(contains(keys(one_bu[one_bu_config_k].base),"projects"), false) ?
          [ for one_project in one_bu[one_bu_config_k].base.projects : one_project.id ] : []) : [])
    ]
  ])
}



check "distinct_project_ids" {
  assert {
    error_message = "No duplicate project IDs please"
    condition = length(local.all_project_ids) == length(distinct(local.all_project_ids))
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}

data "terraform_remote_state" "network_env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/${var.env}"
  }
}

data "terraform_remote_state" "environments_env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/environments/${var.env}"
  }
}
