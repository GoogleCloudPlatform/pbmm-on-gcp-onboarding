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
#                        Production Network                                   #
###############################################################################

module "google_tags_tag_key" {
  source   = "../../modules/25-tags"
  organization = local.organization_config.org_id
  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]  
}
/*
module "google_tags_tag_value" {
  source   = "../../modules/25-tags"
  organization = local.organization_config.org_id # unused
  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]  
}*/

module "project-level-log-sink" {
  source   = "../../modules/23-logging"
  region1   = var.prod_logging.region1
  log_bucket_name = var.prod_logging.log_bucket_name
  gcs_bucket_name = var.prod_logging.gcs_bucket_name
  log_sink_name = var.prod_logging.log_sink_name
  gcs_sink_name = var.prod_logging.gcs_sink_name
  project_id      = module.net-host-prj.project_id
  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall,
    module.project-level-bucket
  ]  
}

module "project-level-bucket" {
  source   = "../../modules/24-gcs-bucket"
  region1   = var.prod_logging.region1
  log_bucket_name = var.prod_logging.log_bucket_name
  gcs_bucket_name = var.prod_logging.gcs_bucket_name
  log_sink_name = var.prod_logging.log_sink_name
  gcs_sink_name = var.prod_logging.gcs_sink_name
  project_id      = module.net-host-prj.project_id
  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]  
}

# place interconnects/router either in nonprod or prod
# FinOps: $8/day before partner attach
module "partner-interconnect-primary" {
  source   = "../../modules/20-partner-interconnect"
  interconnect_router_name    = var.prod-interconnect.interconnect_router_name
  region1   = var.prod-interconnect.region1
  interconnect_router_project_id      = module.net-host-prj.project_id
  interconnect_vpc_name         = module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name] 

  preactivate = var.prod-interconnect.preactivate
  region1_vlan1_name = var.prod-interconnect.region1_vlan1_name
  region1_vlan2_name = var.prod-interconnect.region1_vlan2_name
  region1_vlan3_name = var.prod-interconnect.region1_vlan3_name
  region1_vlan4_name = var.prod-interconnect.region1_vlan4_name
  psc_ip = var.prod-interconnect.psc_ip
  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]  
}


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
    data.terraform_remote_state.common
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

