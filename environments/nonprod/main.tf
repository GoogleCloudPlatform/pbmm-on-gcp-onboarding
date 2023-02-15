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

# Module used to deploy the VPC Service control defined in nonp-vpc-svc-ctl.auto.tfvars
/*module "vpc-svc-ctl" {
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
}*/

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

module "nonprod_projects" {
  for_each                       = { for prj in local.nonprod_projects : prj.name => prj }
  source                         = "../../modules/project"
  billing_account                = each.value.billing_account
  department_code                = local.organization_config.department_code
  user_defined_string            = each.value.user_defined_string
  additional_user_defined_string = each.value.additional_user_defined_string
  owner                          = local.organization_config.owner
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  parent                         = data.terraform_remote_state.common.outputs.folders_map_1_levels["Dev"].id
  labels                         = each.value.labels
  services                       = each.value.services
  shared_vpc_service_config      = each.value.shared_vpc_service_config
}

/*module "nonprod-monitoring-centers" {
  for_each                       = local.merged_monitoring_centers
  source                         = "../../modules/monitoring-center"
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.default_region
  owner                          = local.organization_config.owner
  user_defined_string            = each.value.user_defined_string
  additional_user_defined_string = each.value.additional_user_defined_string
  parent                         = data.terraform_remote_state.common.outputs.folders_map_1_levels["LoggingMonitoring"].id
  billing_account                = local.organization_config.billing_account
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  projectlabels                  = each.value.projectlabels
  project                        = each.value.project
  monitored_projects             = each.value.monitored_projects
  monitoring_viewer_members_list = each.value.monitoring_center_viewers
}*/
