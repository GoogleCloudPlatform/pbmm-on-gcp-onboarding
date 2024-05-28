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
module "base_shared_vpc_project" {
  source = "../single_project"
  count  = (
      try(var.service_project_config != null &&
      contains(keys(var.service_project_config),"project_type"),false) &&
      var.service_project_config.project_type == "service" &&
      contains(keys(var.service_project_config), "base") &&
      try(var.service_project_config.base != null, false)) ? 1:0
  org_id                              = local.org_id
  billing_account                     = local.billing_account
  // MRo: has to be created upstream
  //folder_id                           = google_folder.env_business_unit.name
  environment                         = var.env
  vpc_type                            = "base"
  shared_vpc_host_project_id          = local.base_host_project_id
  // MRo:  shared_vpc_subnets                  = local.base_subnets_self_links
  shared_vpc_subnets                  = var.service_project_config.base.srv_subnet_selflinks
  project_budget                      = var.project_budget
  project_prefix                      = local.project_prefix
  // MRo: disable for now
  enable_cloudbuild_deploy            = local.enable_cloudbuild_deploy
  app_infra_pipeline_service_accounts = local.app_infra_pipeline_service_accounts

  // The roles defined in "sa_roles" will be used to grant the necessary permissions
  // to deploy the resources, a Compute Engine instance for each environment, defined
  // in 5-app-infra step (5-app-infra/modules/env_base/main.tf).
  // The roles are grouped by the repository name ("${var.business_code}-example-app") used to create the Cloud Build workspace
  // (https://github.com/terraform-google-modules/terraform-google-bootstrap/tree/master/modules/tf_cloudbuild_workspace)
  // in the 4-projects shared environment of each business unit.
  // the repository name is the same key used for the app_infra_pipeline_service_accounts map and the
  // roles will be granted to the service account with the same key.
  sa_roles = {
    "${var.business_code}-example-app" = [
      "roles/compute.instanceAdmin.v1",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
    ]
  }

  activate_apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]

  # Metadata
  //project_suffix    = "simple-base"
// TODO : clean up
//project_suffix    = lower(replace(var.service_project_config.base.project_id,"_","-"))
  project_suffix    = "-b-${lower(replace(substr(var.service_project_config.base.project_id, length(var.service_project_config.base.project_id)-2,2),"_","-"))}"
  application_name  = "${var.business_code}-${var.service_project_config.base.project_app}"
  billing_code      = var.service_project_config.billing_code
  primary_contact   = var.service_project_config.primary_contact
  secondary_contact = var.service_project_config.secondary_contact
  business_code     = var.business_code
  folder_id         = var.service_project_config.folder_id
}


