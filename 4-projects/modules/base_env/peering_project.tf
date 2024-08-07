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
locals {
  env_code = substr(var.env, 0, 1)
}
module "base_peering_project" {
  source = "../single_project"
  count = (
    try(var.peering_project_config != null &&
    contains(keys(var.peering_project_config), "project_type"), false) &&
    var.peering_project_config.project_type == "peering" &&
    contains(keys(var.peering_project_config), "base") &&
  try(var.peering_project_config.base != null, false)) ? 1 : 0

  org_id          = local.org_id
  billing_account = local.billing_account
  environment     = var.env
  project_budget  = var.project_budget
  project_prefix  = local.project_prefix

  // Enabling Cloud Build Deploy to use Service Accounts during the build and give permissions to the SA.
  // The permissions will be the ones necessary for the deployment of the step 5-app-infra
  enable_cloudbuild_deploy = local.enable_cloudbuild_deploy

  // A map of Service Accounts to use on the infra pipeline (Cloud Build)
  // Where the key is the repository name ("${var.business_code}-example-app")
  app_infra_pipeline_service_accounts = local.app_infra_pipeline_service_accounts

  // Map for the roles where the key is the repository name ("${var.business_code}-example-app")
  // and the value is the list of roles that this SA need to deploy step 5-app-infra
  sa_roles = {
    "${var.business_code}-example-app" = [
      "roles/compute.instanceAdmin.v1",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
      "roles/resourcemanager.tagUser",
    ]
  }

  activate_apis = [
    "dns.googleapis.com"
  ]

  # Metadata
  //project_suffix    = lower(replace(var.peering_project_config.base.project_id,"_","-"))
  //project_suffix    = lower(replace(substr(var.peering_project_config.base.project_id, length(var.peering_project_config.base.project_id)-2,2),"_","-"))
  project_suffix    = "-b-${lower(replace(substr(var.peering_project_config.base.project_id, length(var.peering_project_config.base.project_id) - 6, 6), "_", "-"))}"
  application_name  = "${var.business_code}-${var.peering_project_config.base.project_app}"
  billing_code      = var.peering_project_config.billing_code
  primary_contact   = var.peering_project_config.primary_contact
  secondary_contact = var.peering_project_config.secondary_contact
  business_code     = var.business_code
  folder_id         = var.peering_project_config.folder_id
  vpc_type          = "base"
}

module "restricted_peering_project" {
  source = "../single_project"
  count = (
    try(var.peering_project_config != null &&
    contains(keys(var.peering_project_config), "project_type"), false) &&
    var.peering_project_config.project_type == "peering" &&
    contains(keys(var.peering_project_config), "restricted") &&
  try(var.peering_project_config.restricted != null, false)) ? 1 : 0

  org_id          = local.org_id
  billing_account = local.billing_account
  environment     = var.env
  project_budget  = var.project_budget
  project_prefix  = local.project_prefix

  // Enabling Cloud Build Deploy to use Service Accounts during the build and give permissions to the SA.
  // The permissions will be the ones necessary for the deployment of the step 5-app-infra
  enable_cloudbuild_deploy = local.enable_cloudbuild_deploy

  // A map of Service Accounts to use on the infra pipeline (Cloud Build)
  // Where the key is the repository name ("${var.business_code}-example-app")
  app_infra_pipeline_service_accounts = local.app_infra_pipeline_service_accounts

  // Map for the roles where the key is the repository name ("${var.business_code}-example-app")
  // and the value is the list of roles that this SA need to deploy step 5-app-infra
  sa_roles = {
    "${var.business_code}-example-app" = [
      "roles/compute.instanceAdmin.v1",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
      "roles/resourcemanager.tagUser",
    ]
  }

  activate_apis = [
    "dns.googleapis.com"
  ]

  # Metadata
  //project_suffix    = lower(replace(var.peering_project_config.restricted.project_id,"_","-"))
  //project_suffix    = lower(replace(substr(var.peering_project_config.restricted.project_id, length(var.peering_project_config.restricted.project_id)-2,2),"_","-"))
  project_suffix    = "-r-${lower(replace(substr(var.peering_project_config.restricted.project_id, length(var.peering_project_config.restricted.project_id) - 6, 6), "_", "-"))}"
  application_name  = "${var.business_code}-${var.peering_project_config.restricted.project_app}"
  billing_code      = var.peering_project_config.billing_code
  primary_contact   = var.peering_project_config.primary_contact
  secondary_contact = var.peering_project_config.secondary_contact
  business_code     = var.business_code
  folder_id         = var.peering_project_config.folder_id
  vpc_type          = "restricted"
}

module "base_peering_net" {
  source = "../peering_net"
  count = (
    try(var.peering_project_config != null &&
    contains(keys(var.peering_project_config), "project_type"), false) &&
    var.peering_project_config.project_type == "peering" &&
    contains(keys(var.peering_project_config), "base") &&
  try(var.peering_project_config.base != null, false)) ? 1 : 0
  env                          = var.env
  peering_module_depends_on    = var.peering_module_depends_on
  firewall_enable_logging      = var.firewall_enable_logging
  optional_fw_rules_enabled    = var.optional_fw_rules_enabled
  windows_activation_enabled   = var.windows_activation_enabled
  vpc_flow_logs                = var.vpc_flow_logs
  project_budget               = var.project_budget
  peering_iap_fw_rules_enabled = var.peering_iap_fw_rules_enabled
  //subnet_region = var.subnet_region
  //subnet_ip_range = var.subnet_ip_range
  business_code          = var.business_code
  peering_project_id     = module.base_peering_project[0].project_id
  peer_network_self_link = local.base_network_self_link
  subnet_config          = { for subnet_region, subnet_ip_range in var.peering_project_config.base.ip_ranges_by_region : subnet_region => subnet_ip_range }
}

module "restricted_peering_net" {
  source = "../peering_net"
  count = (
    try(var.peering_project_config != null &&
    contains(keys(var.peering_project_config), "project_type"), false) &&
    var.peering_project_config.project_type == "peering" &&
    contains(keys(var.peering_project_config), "restricted") &&
  try(var.peering_project_config.restricted != null, false)) ? 1 : 0
  env                          = var.env
  peering_module_depends_on    = var.peering_module_depends_on
  firewall_enable_logging      = var.firewall_enable_logging
  optional_fw_rules_enabled    = var.optional_fw_rules_enabled
  windows_activation_enabled   = var.windows_activation_enabled
  vpc_flow_logs                = var.vpc_flow_logs
  project_budget               = var.project_budget
  peering_iap_fw_rules_enabled = var.peering_iap_fw_rules_enabled
  business_code                = var.business_code
  peering_project_id           = module.restricted_peering_project[0].project_id
  peer_network_self_link       = local.restricted_network_self_link
  subnet_config                = { for subnet_region, subnet_ip_range in var.peering_project_config.restricted.ip_ranges_by_region : subnet_region => subnet_ip_range }
}

