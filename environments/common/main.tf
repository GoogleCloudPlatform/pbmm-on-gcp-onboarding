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
#                        Terraform top-level resources                        #
###############################################################################

/* module "access-context-manager" {
  source              = "../../modules/vpc-service-controls"
  parent_id           = local.organization_config.org_id
  policy_name         = var.access_context_manager.policy_name
  policy_id           = var.access_context_manager.policy_id
  access_level        = var.access_context_manager.access_level
  department_code     = local.organization_config.department_code
  environment         = local.organization_config.environment
  location            = local.organization_config.default_region
  user_defined_string = var.access_context_manager.user_defined_string
}
*/

module "core-audit-bunker" {
  source                         = "../../modules/audit-bunker"
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  billing_account                = var.audit.billing_account
  parent                         = module.core-folders.folders_map_1_level["Audit"].id
  audit_streams                  = var.audit.audit_streams
  org_id                         = local.organization_config.org_id
  region                         = local.organization_config.default_region
  labels                         = var.audit.audit_labels
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  owner                          = local.organization_config.owner
  user_defined_string            = var.audit.user_defined_string
  additional_user_defined_string = var.audit.additional_user_defined_string
  bucket_name                    = var.audit.audit_streams.prod.bucket_name
  is_locked                      = var.audit.audit_streams.prod.is_locked
  bucket_force_destroy           = var.audit.audit_streams.prod.bucket_force_destroy
  bucket_storage_class           = var.audit.audit_streams.prod.bucket_storage_class
  sink_name                      = var.audit.audit_streams.prod.sink_name
  description                    = var.audit.audit_streams.prod.description
  filter                         = var.audit.audit_streams.prod.filter
  retention_period               = var.audit.audit_streams.prod.retention_period

  depends_on = [
    module.core-folders
  ]
}

module "core-folders" {
  source                  = "../../modules/folder"
  parent                  = var.folders.parent
  names                   = var.folders.names
  subfolders_first_level  = var.folders.subfolders_1
  subfolders_second_level = var.folders.subfolders_2
}

module "core-iam" {
  source                  = "../../modules/iam"
  sa_create_assign        = var.service_accounts
  organization_iam        = var.organization_iam
  organization            = local.organization_config.org_id
  folder_iam              = local.folder_iam
  project_iam             = local.project_iam
  custom_role_name_id_map = module.core-org-custom-roles.role_ids
  depends_on = [
    module.core-org-custom-roles,
    module.core-folders,
    module.core-guardrails,
    module.core-audit-bunker,
  ]
}

module "core-org-custom-roles" {
  source              = "../../modules/org-custom-roles"
  org_id              = local.organization_config.org_id
  custom_roles        = var.custom_roles
  department_code     = local.organization_config.department_code
  environment         = local.organization_config.environment
  location            = local.organization_config.default_region
  user_defined_string = var.audit.user_defined_string
}

module "core-org-policy" {
  source                       = "../../modules/organization-policy"
  organization_id              = local.organization_config.org_id
  directory_customer_id        = var.org_policies.directory_customer_id
  vms_allowed_with_external_ip = var.org_policies.vmAllowedWithExternalIp
  vms_allowed_with_ip_forward  = var.org_policies.vmAllowedWithIpForward
  policy_boolean               = var.org_policies.policy_boolean
  policy_list                  = var.org_policies.policy_list
  set_default_policy           = var.org_policies.setDefaultPolicy
}

module "core-guardrails" {
  source               = "../../modules/guardrails"
  parent               = module.core-folders.folders_map_1_level["Security"].id
  org_id               = local.organization_config.org_id
  billing_account      = local.organization_config.billing_account
  org_id_scan_list     = var.guardrails.org_id_scan_list
  org_client           = var.guardrails.org_client
  region               = local.organization_config.default_region
  user_defined_string  = var.guardrails.user_defined_string
  department_code      = local.organization_config.department_code
  environment          = local.organization_config.environment
  owner                = local.organization_config.owner
  terraform_sa_project = data.terraform_remote_state.bootstrap.outputs.project_id
}

/*module "core-logging-centers" {
  for_each                       = local.merged_logging_centers
  source                         = "../../modules/logging-center"
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.default_region
  owner                          = local.organization_config.owner
  user_defined_string            = each.value.user_defined_string
  additional_user_defined_string = each.value.additional_user_defined_string
  parent                         = module.core-folders.folders_map_1_level["LoggingMonitoring"].id
  billing_account                = local.organization_config.billing_account
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  projectlabels                  = each.value.projectlabels
  simple_central_log_bucket      = each.value.central_log_bucket
  log_bucket_viewer_members_list = each.value.logging_center_viewers
}*/

# Uncomment the below block after initial deployment
# module "core-organization-monitoring-centers" {
#   for_each                       = local.merged_monitoring_centers
#   source                         = "../../modules/monitoring-center"
#   department_code                = local.organization_config.department_code
#   environment                    = local.organization_config.environment
#   location                       = local.organization_config.default_region
#   owner                          = local.organization_config.owner
#   user_defined_string            = each.value.user_defined_string
#   additional_user_defined_string = each.value.additional_user_defined_string
#   parent                         = module.core-folders.folders_map_1_level["LoggingMonitoring"].id
#   billing_account                = local.organization_config.billing_account
#   tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
#   projectlabels                  = each.value.projectlabels
#   project                        = each.value.project
#   monitored_projects             = each.value.monitored_projects
#   monitoring_viewer_members_list = each.value.monitoring_center_viewers
# }

###############################################################################
#                        Perimeter Networking                                 #
############################################################################### 
module "net-perimeter-prj" {
  source                         = "../../modules/network-host-project"
  services                       = var.public_perimeter_net.services
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  billing_account                = local.organization_config.billing_account
  parent                         = module.core-folders.folders_map_2_levels["ProdNetworking"].id
  networks                       = var.public_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  projectlabels                  = var.public_perimeter_net.labels
  owner                          = local.organization_config.owner
  user_defined_string            = var.public_perimeter_net.user_defined_string
  additional_user_defined_string = var.public_perimeter_net.additional_user_defined_string
  depends_on                     = []
}

module "net-ha-perimeter" {
  source                         = "../../modules/network"
  project_id                     = module.net-perimeter-prj.project_id
  services                       = var.ha_perimeter_net.services
  billing_account                = local.organization_config.billing_account
  parent                         = module.core-folders.folders_map_2_levels["ProdNetworking"].id
  networks                       = var.ha_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.ha_perimeter_net.user_defined_string
  additional_user_defined_string = var.ha_perimeter_net.additional_user_defined_string
  depends_on                     = []
}

module "net-mgmt-perimeter" {
  source                         = "../../modules/network"
  project_id                     = module.net-perimeter-prj.project_id
  services                       = var.management_perimeter_net.services
  billing_account                = local.organization_config.billing_account
  parent                         = module.core-folders.folders_map_2_levels["ProdNetworking"].id
  networks                       = var.management_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.management_perimeter_net.user_defined_string
  additional_user_defined_string = var.management_perimeter_net.additional_user_defined_string
  depends_on                     = []
}

module "net-private-perimeter" {
  source                         = "../../modules/network"
  project_id                     = module.net-perimeter-prj.project_id
  services                       = var.private_perimeter_net.services
  billing_account                = local.organization_config.billing_account
  parent                         = module.core-folders.folders_map_2_levels["ProdNetworking"].id
  networks                       = var.private_perimeter_net.networks
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.private_perimeter_net.user_defined_string
  additional_user_defined_string = var.private_perimeter_net.additional_user_defined_string
  depends_on                     = []
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

module "net-public-perimeter-firewall" { #net-perimeter-prj-firewall
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

/*data "google_projects" "monitored_projects" {
  for_each = local.monitored_project_search_filter_map
  provider = google-beta
  filter   = each.value
}*/
