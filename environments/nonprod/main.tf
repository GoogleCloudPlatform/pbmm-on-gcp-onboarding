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


###############################################################################
#                        Non-Production Network                               #
###############################################################################

# FinOps: $8/day before partner attach
module "partner-interconnect-primary" {
  source   = "../../modules/20-partner-interconnect"
  interconnect_router_name    = var.nonprod-interconnect.interconnect_router_name
  region1   = var.nonprod-interconnect.region1
  interconnect_router_project_id      = module.net-host-prj.project_id
  interconnect_vpc_name         = module.net-host-prj.network_name[var.nonprod_host_net.networks[0].network_name] 

  preactivate = var.nonprod-interconnect.preactivate
  region1_vlan1_name = var.nonprod-interconnect.region1_vlan1_name
  region1_vlan2_name = var.nonprod-interconnect.region1_vlan2_name
  region1_vlan3_name = var.nonprod-interconnect.region1_vlan3_name
  region1_vlan4_name = var.nonprod-interconnect.region1_vlan4_name
  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]  
}

# Module used to deploy the VPC Service control defined in nonp-vpc-svc-ctl.auto.tfvars
module "vpc-svc-ctl" {
  source                    = "../../modules/vpc-service-controls"
  policy_id                 = data.terraform_remote_state.common.outputs.access_context_manager_policy_id 
  parent_id                 = data.terraform_remote_state.common.outputs.access_context_manager_parent_id 
  regular_service_perimeter = var.nonprod_vpc_svc_ctl.regular_service_perimeter
  bridge_service_perimeter  = var.nonprod_vpc_svc_ctl.bridge_service_perimeter
  department_code           = local.organization_config.department_code
  environment               = local.organization_config.environment
  location                  = local.organization_config.location
  user_defined_string       = data.terraform_remote_state.common.outputs.audit_config.user_defined_string

  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]
}

# Module use to deploy a project with a virtual private cloud
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


# Module is used to deploy firewall rules for the network host project 
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

