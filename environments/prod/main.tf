/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/
###############################################################################
#                        Production Network                                   #
###############################################################################

module "net-host-prj" {
  source                         = "../../modules/network-host-project"
  services                       = var.prod_host_net.services
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  billing_account                = local.organization_config.billing_account
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.ProdNetworking.id
  networks                       = var.prod_host_net.networks
  projectlabels                  = var.prod_host_net.labels
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.prod_host_net.user_defined_string
  additional_user_defined_string = var.prod_host_net.additional_user_defined_string
  depends_on                     = [
    module.net-private-perimeter
  ]
}

module "vpc-svc-ctl" {
  source                    = "../../modules/vpc-service-controls"
  policy_id                 = data.terraform_remote_state.common.outputs.access_context_manager_policy_id
  parent_id                 = data.terraform_remote_state.common.outputs.access_context_manager_parent_id
  regular_service_perimeter = local.prod_vpc_svc_ctl.regular_service_perimeter
  bridge_service_perimeter  = local.prod_vpc_svc_ctl.bridge_service_perimeter
  department_code           = local.organization_config.department_code
  environment               = local.organization_config.environment
  location                  = local.organization_config.location

  user_defined_string       = data.terraform_remote_state.common.outputs.audit_config.user_defined_string

  depends_on = [
    module.net-host-prj
  ]
}

module "firewall" {
  source          = "../../modules/firewall"
  project_id      = module.net-host-prj.project_id
  network         = module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name] 
  custom_rules    = var.prod_firewall.custom_rules
  department_code = local.organization_config.department_code
  environment     = local.organization_config.environment
  location        = local.organization_config.location
  depends_on = [
    module.net-host-prj
  ]
}

#### Perimeter
module "net-perimeter-prj" {
  source                         = "../../modules/network-host-project"
  services                       = var.public_perimeter_net.services
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  billing_account                = local.organization_config.billing_account
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.ProdNetworking.id
  networks                       = var.public_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  projectlabels                  = var.public_perimeter_net.labels
  owner                          = local.organization_config.owner
  user_defined_string            = var.public_perimeter_net.user_defined_string
  additional_user_defined_string = var.public_perimeter_net.additional_user_defined_string
  depends_on = []
}

module "net-ha-perimeter" {
  source                         = "../../modules/network"
  project_id                     = module.net-perimeter-prj.project_id
  services                       = var.ha_perimeter_net.services
  billing_account                = local.organization_config.billing_account
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.ProdNetworking.id
  networks                       = var.ha_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.ha_perimeter_net.user_defined_string
  additional_user_defined_string = var.ha_perimeter_net.additional_user_defined_string
  depends_on = []
}

module "net-mgmt-perimeter" {
  source                         = "../../modules/network"
  project_id                     = module.net-perimeter-prj.project_id
  services                       = var.management_perimeter_net.services
  billing_account                = local.organization_config.billing_account
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.ProdNetworking.id
  networks                       = var.management_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.management_perimeter_net.user_defined_string
  additional_user_defined_string = var.management_perimeter_net.additional_user_defined_string
  depends_on = []
}

module "net-private-perimeter" {
  source                         = "../../modules/network"
  project_id                     = module.net-perimeter-prj.project_id
  services                       = var.private_perimeter_net.services
  billing_account                = local.organization_config.billing_account
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.ProdNetworking.id 
  networks                       = var.private_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.private_perimeter_net.user_defined_string
  additional_user_defined_string = var.private_perimeter_net.additional_user_defined_string
  depends_on = []
}

module "net-private-perimeter-firewall" { #net-private-perimeter firewall
  source          = "../../modules/firewall"
  project_id      = module.net-private-perimeter.project_id
  network         = module.net-private-perimeter.network_name[var.private_perimeter_net.networks[0].network_name]
  zone_list       = []
  custom_rules    = var.prod_private_perimeter_firewall.custom_rules
  department_code = local.organization_config.department_code
  environment     = local.organization_config.environment
  location        = local.organization_config.location
  depends_on = [
    module.net-private-perimeter
  ]
}

module "net-public-perimeter-firewall" {  #net-perimeter-prj-firewall
  source          = "../../modules/firewall"
  project_id      = module.net-perimeter-prj.project_id
  network         = module.net-perimeter-prj.network_name[var.public_perimeter_net.networks[0].network_name] 
  zone_list       = []
  custom_rules    = var.prod_public_perimeter_firewall.custom_rules
  department_code = local.organization_config.department_code
  environment     = local.organization_config.environment
  location        = local.organization_config.location
  depends_on = [
    module.net-private-perimeter
  ]
}