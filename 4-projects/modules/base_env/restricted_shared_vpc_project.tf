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
// MRo: changed name to *.tf.example as it should be for an example
module "restricted_shared_vpc_project" {
  source = "../single_project"
  count = (
    try(var.service_project_config != null &&
    contains(keys(var.service_project_config), "project_type"), false) &&
    var.service_project_config.project_type == "service" &&
    contains(keys(var.service_project_config), "restricted") &&
  try(var.service_project_config.restricted != null, false)) ? 1 : 0
  org_id          = local.org_id
  billing_account = local.billing_account
  // MRo: has to be created upstream
  // folder_id                  = google_folder.env_business_unit.name
  environment                = var.env
  vpc_type                   = "restricted"
  shared_vpc_host_project_id = local.restricted_host_project_id
  //MRo: shared_vpc_subnets         = local.restricted_subnets_self_links
  shared_vpc_subnets = var.service_project_config.restricted.srv_subnet_selflinks
  project_budget     = var.project_budget
  project_prefix     = local.project_prefix


  activate_apis = ["accesscontextmanager.googleapis.com"]
  // MRo : not by default
  // vpc_service_control_attach_enabled = true
  vpc_service_control_attach_enabled = var.service_project_config.restricted_vpc_scp_enabled
  vpc_service_control_perimeter_name = "accessPolicies/${local.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"
  vpc_service_control_sleep_duration = "60s"

  # Metadata
  // TODO: cleanup
  //  project_suffix    = lower(replace(var.service_project_config.restricted.project_id,"_","-"))
  //  project_suffix    = lower(replace(substr(var.service_project_config.restricted.project_id, length(var.service_project_config.restricted.project_id)-2,2),"_","-"))
  project_suffix    = "-r-${lower(replace(substr(var.service_project_config.restricted.project_id, length(var.service_project_config.restricted.project_id) - 6, 6), "_", "-"))}"
  application_name  = "${var.business_code}-${var.service_project_config.restricted.project_app}"
  billing_code      = var.service_project_config.billing_code
  primary_contact   = var.service_project_config.primary_contact
  secondary_contact = var.service_project_config.secondary_contact
  business_code     = var.business_code
  folder_id         = var.service_project_config.folder_id
}
