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

locals {
  cicd_project_id = module.base_cicd.project_id
  state_bucket_kms_key = "projects/${module.seed_bootstrap.seed_project_id}/locations/${var.default_region}/keyRings/${var.project_prefix}-keyring/cryptoKeys/${var.project_prefix}-key"

}

module "base_cicd" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "${var.project_prefix}-b-cicd"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.bootstrap.id
  billing_account   = var.billing_account
  activate_apis = [
    "compute.googleapis.com",
    "admin.googleapis.com",
    "iam.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
  ]
}

module "gcp_projects_state_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 6.0"

  name          = "${var.bucket_prefix}-${module.seed_bootstrap.seed_project_id}-gcp-projects-tfstate"
  project_id    = module.seed_bootstrap.seed_project_id
  location      = var.default_region
  force_destroy = var.bucket_force_destroy

  encryption = {
    default_kms_key_name = local.state_bucket_kms_key
  }

  depends_on = [module.seed_bootstrap.gcs_bucket_tfstate]
}