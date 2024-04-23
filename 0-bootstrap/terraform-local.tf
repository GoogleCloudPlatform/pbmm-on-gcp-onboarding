locals {
##  cicd_project_id = var.cicd_project_id
  cicd_project_id = module.local_cicd.project_id
}

module "local_cicd" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name              = "${var.project_prefix}-b-cicd-local"
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

