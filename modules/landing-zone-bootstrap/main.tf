/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "project" {
  source                         = "./../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
  labels                         = local.labels
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services                       = local.merged_services
}

####### 
resource "google_service_account" "org_terraform" {
  project      = module.project.project_id
  account_id   = var.terraform_deployment_account
  display_name = "Terraform Deployment Account"
}

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = toset(local.org_roles)

  org_id     = var.org_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.org_terraform.email}"
  depends_on = [module.project]
}

###### cloud build as terraform deployer
resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
  for_each = toset(local.org_roles)

  org_id     = var.org_id
  role       = each.value
  member     = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
  depends_on = [module.project]
}

###### Bootstrap project permissions
resource "google_project_iam_member" "tf_sa_project_perms_cb" {
  for_each = toset(local.project_roles)
  project  = module.project.project_id
  role     = each.value
  member   = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_billing_account_iam_member" "tf_billing_user" {
  count              = var.set_billing_iam ? 1 : 0
  billing_account_id = var.billing_account
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.org_terraform.email}"
}
resource "google_billing_account_iam_member" "tf_billing_user_cb" {
  count              = var.set_billing_iam ? 1 : 0
  billing_account_id = var.billing_account
  role               = "roles/billing.user"
  member             = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}

##### State Buckets and IAM 
resource "google_project_iam_member" "manage_buckets" {
  project = module.project.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.org_terraform.email}"
}

resource "google_project_iam_member" "manage_buckets_bstrap" {
  project = module.project.project_id
  role    = "roles/storage.objectViewer"
  member  = var.bootstrap_email
}

resource "google_storage_bucket" "org_terraform_state" {
  for_each                    = var.tfstate_buckets
  project                     = module.project.project_id
  name                        = module.state_bucket_names[each.key].result
  location                    = var.default_region
  labels                      = lookup(each.value, "labels", {})
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  force_destroy = lookup(each.value, "force_destroy", false)
  storage_class = lookup(each.value, "storage_class", "REGIONAL") # STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE
}

resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam" {
  for_each = google_storage_bucket.org_terraform_state
  bucket   = each.value.name
  role     = "roles/storage.objectCreator"
  member   = "serviceAccount:${google_service_account.org_terraform.email}"
}
resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb" {
  for_each = google_storage_bucket.org_terraform_state
  bucket   = each.value.name
  role     = "roles/storage.objectCreator"
  member   = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}

##### User or Group to upload bootstrap terraform state
resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email" {
  for_each = google_storage_bucket.org_terraform_state
  bucket   = each.value.name
  role     = "roles/storage.admin"
  member   = var.bootstrap_email
}

##### Create source repository for Configuration
resource "google_sourcerepo_repository" "csr" {
  name       = var.cloud_source_repo_name
  project    = module.project.project_id
  depends_on = [module.project]
}

  resource "google_sourcerepo_repository_iam_member" "sa_member" {
    project    = module.project.project_id
    repository = google_sourcerepo_repository.csr.name
    role       = "roles/source.writer"
    member     = "serviceAccount:${google_service_account.org_terraform.email}"
    depends_on = [module.project]
  }
  resource "google_sourcerepo_repository_iam_member" "sa_member_cb" {
    project    = module.project.project_id
    repository = google_sourcerepo_repository.csr.name
    role       = "roles/source.writer"
    member     = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
    depends_on = [module.project]
  }

resource "google_sourcerepo_repository_iam_member" "iam_member" {
  project    = module.project.project_id
  repository = google_sourcerepo_repository.csr.name
  role       = "roles/source.admin"
  member     = var.bootstrap_email
  depends_on = [module.project]
}