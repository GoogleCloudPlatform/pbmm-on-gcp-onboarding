/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/
###############################################################################
#                        Non-Production Network                               #
###############################################################################

module "vpc-svc-ctl" {
  source                    = "../../modules/vpc-service-controls"
  policy_id                 = data.terraform_remote_state.common.outputs.access_context_manager_policy_id 
  parent_id                 = data.terraform_remote_state.common.outputs.access_context_manager_parent_id 
  regular_service_perimeter = local.nonprod_vpc_svc_ctl.regular_service_perimeter
  bridge_service_perimeter  = local.nonprod_vpc_svc_ctl.bridge_service_perimeter
  department_code           = local.organization_config.department_code
  environment               = local.organization_config.environment
  location                  = local.organization_config.location
  user_defined_string       = "${data.terraform_remote_state.common.outputs.audit_config.user_defined_string}nonprod"

  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]
}

module "net-host-prj" {
  source                         = "../../modules/network-host-project"
  services                       = var.nonprod_host_net.services
  billing_account                = local.organization_config.billing_account
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.NonProdNetworking.id 
  networks                       = var.nonprod_host_net.networks
  projectlabels                  = var.nonprod_host_net.labels
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.nonprod_host_net.user_defined_string
  additional_user_defined_string = var.nonprod_host_net.additional_user_defined_string
  depends_on = [
    data.terraform_remote_state.common
  ]
}


module "firewall" {
  source          = "../../modules/firewall"
  project_id      = module.net-host-prj.project_id
  network         = module.net-host-prj.network_name[var.nonprod_host_net.networks[0].network_name] 
  custom_rules    = var.nonprod_firewall.custom_rules
  department_code = local.organization_config.department_code
  environment     = local.organization_config.environment
  location        = local.organization_config.location
  depends_on = [
    module.net-host-prj
  ]
}

