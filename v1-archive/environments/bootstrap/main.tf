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


module "landing_zone_bootstrap" {
  source                         = "../../modules/landing-zone-bootstrap"
  billing_account                = var.bootstrap.billingAccount
  parent                         = var.bootstrap.parent
  terraform_deployment_account   = var.bootstrap.terraformDeploymentAccount
  bootstrap_email                = var.bootstrap.bootstrapEmail
  tfstate_buckets                = var.bootstrap.tfstate_buckets
  services                       = var.bootstrap.projectServices
  cloud_source_repo_name         = var.bootstrap.cloud_source_repo_name
  labels                         = var.organization_config.labels
  org_id                         = var.organization_config.org_id
  department_code                = var.organization_config.department_code
  environment                    = var.organization_config.environment
  location                       = var.organization_config.location
  owner                          = var.organization_config.owner
  user_defined_string            = var.bootstrap.userDefinedString
  additional_user_defined_string = var.bootstrap.additionalUserDefinedString
}

# Cloud Build Bootstrap

module "cloudbuild_bootstrap" {
  source                  = "../../modules/cloudbuild"
  org_id                  = var.organization_config.org_id
  org_folder              = var.organization_config.root_node
  project_id              = module.landing_zone_bootstrap.project_id
  project_prefix          = lower(var.bootstrap.userDefinedString)
  parent                  = var.organization_config.root_node
  billing_account         = var.organization_config.billing_account
  department_code         = var.organization_config.department_code
  environment             = var.organization_config.environment
  owner                   = var.organization_config.owner
  group_org_admins        = var.cloud_build_admins
  group_build_viewers     = var.group_build_viewers
  default_region          = var.organization_config.default_region
  sa_enable_impersonation = true
  terraform_sa_email      = { sa = module.landing_zone_bootstrap.service_account_email }
  terraform_sa_project    = module.landing_zone_bootstrap.project_id
  terraform_state_bucket  = module.landing_zone_bootstrap.tfstate_bucket_names
  random_suffix           = false
  cloud_source_repo_name  = var.bootstrap.cloud_source_repo_name
  cloud_build_config      = var.cloud_build_config
  depends_on = [
    module.landing_zone_bootstrap
  ]
}

# Add IAM for the bootstrap service account to manage IAM for the Cloud Build GAR
resource "google_artifact_registry_repository_iam_member" "terraform-image-iam" {
  provider   = google-beta
  project    = module.cloudbuild_bootstrap.cloudbuild_project_id
  repository = module.cloudbuild_bootstrap.tf_runner_artifact_repo
  location   = var.organization_config.default_region
  role       = "roles/artifactregistry.admin"
  member     = "serviceAccount:${module.landing_zone_bootstrap.service_account_email}"

}

/*
# Allow admins to impersonate all service accounts.
resource "google_service_account_iam_member" "terraform_sa_impersonate_permissions" {
  for_each           = module.tf-service-accounts
  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.value.email}"
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = var.sa_impersonation_admins
}

# Allow specific IAM entites to impersonate specific service accounts.
resource "google_service_account_iam_member" "terraform_specific_sa_impersonate_permissions" {
  for_each = {for grant in var.sa_impersonation_grants: "${grant.folder}-${grant.env}" => grant.impersonator}

  service_account_id = "projects/${var.project_id}/serviceAccounts/${module.tf-service-accounts[each.key].email}"
  role = "roles/iam.serviceAccountTokenCreator"
  member = each.value
}
*/