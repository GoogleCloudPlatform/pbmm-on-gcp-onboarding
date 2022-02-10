/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "guardrails_project" {
  source                         = "../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.region
  parent                         = var.parent
  tf_service_account_email      = var.tf_service_account_email
  services = [
    "artifactregistry.googleapis.com",
    "appengine.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudscheduler.googleapis.com",
    "containerregistry.googleapis.com",
    "sourcerepo.googleapis.com",
    "storage.googleapis.com"
  ]
}

# Create guardrails if this is the main org
module "guardrails" {
  count = var.org_client ? 0 : 1

  source                         = "./modules/guardrails"
  org_id                         = var.org_id
  org_id_scan_list               = var.org_id_scan_list
  project_id                     = module.guardrails_project.project_id
  environment                    = var.environment
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string

  depends_on = [
    module.guardrails_project
  ]
}

# Only create satelite buckets if this is a client org
resource "google_storage_bucket" "guardrails_reports_bucket" {
  count = var.org_client ? 1 : 0

  project       = module.guardrails_project.project_id
  location      = var.region
  name          = module.client_reports_bucket.result
  force_destroy = true
}