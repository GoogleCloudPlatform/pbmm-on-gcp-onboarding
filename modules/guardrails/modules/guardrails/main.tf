/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

data "google_project" "guardrails_project" {
  project_id = var.project_id
}

data "google_project" "bootstrap_project" {
  project_id = var.terraform_sa_project
}

resource "google_service_account" "guardrails_service_account" {
  project      = var.project_id
  account_id   = local.default_guardrails_service_account_name
  display_name = "Guardrails Service Account"
}

resource "google_project_iam_member" "bootstrap_cloudbuild_builder" {
  project      = data.google_project.bootstrap_project.project_id
  role         = "roles/cloudbuild.builds.editor"
  member       = "serviceAccount:${data.google_project.bootstrap_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_organization_iam_member" "guardrails_service_account_asset_viewer_permissions" {
  for_each = toset(var.org_id_scan_list)
  org_id   = each.key
  role     = "roles/cloudasset.viewer"
  member   = "serviceAccount:${google_service_account.guardrails_service_account.email}"
}

resource "google_organization_iam_member" "single_org_service_account_asset_viewer_permission" {
  count  = (length(var.org_id_scan_list) == 0 ? 1 : 0)
  org_id = var.org_id
  role   = "roles/cloudasset.viewer"
  member = "serviceAccount:${google_service_account.guardrails_service_account.email}"
}

resource "google_sourcerepo_repository" "guardrails_policies" {
  project = var.project_id
  name    = local.cloud_source_repos.default_policies_repo_name
}

resource "google_sourcerepo_repository_iam_member" "guardrails_sa_csr_iam_policy" {
  project    = var.project_id
  repository = google_sourcerepo_repository.guardrails_policies.name
  role       = "roles/source.reader"
  member     = "serviceAccount:${google_service_account.guardrails_service_account.email}"
}

resource "google_sourcerepo_repository_iam_member" "cloudbuild_csr_iam_policy" {
  project    = var.project_id
  repository = google_sourcerepo_repository.guardrails_policies.name
  role       = "roles/source.writer"
  member     = "serviceAccount:${data.google_project.guardrails_project.number}@cloudbuild.gserviceaccount.com"
}

resource "null_resource" "guardrails_policies_clone" {
  provisioner "local-exec" {
    command = "gcloud builds submit --no-source --config=${path.module}/cloudbuild-bootstrap.yaml --project=${var.project_id} --substitutions=_GUARDRAILS_POLICIES_CSR_NAME=${local.cloud_source_repos.default_policies_repo_name} --quiet --async"
  }
  depends_on = [
    google_sourcerepo_repository.guardrails_policies,
    google_sourcerepo_repository_iam_member.guardrails_sa_csr_iam_policy,
    google_sourcerepo_repository_iam_member.cloudbuild_csr_iam_policy
  ]
}

resource "google_storage_bucket" "guardrails_asset_inventory_bucket" {
  project                     = var.project_id
  location                    = var.region
  name                        = local.cloud_storage.asset_inventory_bucket_name
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "guardrails_reports_bucket" {
  project                     = var.project_id
  location                    = var.region
  name                        = local.cloud_storage.asset_inventory_reports_bucket_name
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_artifact_registry_repository" "guardrails_artifact_registry" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = local.cloud_artifact_registry.default_artifact_registry_name
  description   = "An artifact repository which will contain the container images for guardrails validation"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "guardrails_artifact_registry_iam" {
  provider   = google-beta
  project    = google_artifact_registry_repository.guardrails_artifact_registry.project
  location   = google_artifact_registry_repository.guardrails_artifact_registry.location
  repository = google_artifact_registry_repository.guardrails_artifact_registry.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.guardrails_service_account.email}"
}

resource "google_cloudbuild_trigger" "guardrails_build_docker" {
  project     = var.project_id
  name        = local.cloud_build.default_container_build_pipeline_name
  description = "Builds a guardrail validation container from CSR repo"

  trigger_template {
    branch_name = var.trigger_branch_name
    repo_name   = google_sourcerepo_repository.guardrails_policies.name
    dir         = "guardrails-validation"
  }

  build {
    step {
      name = "docker"
      args = ["build", "-t", "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.guardrails_artifact_registry.name}/${local.guardrails_policies_container.name}:${local.guardrails_policies_container.tag}", "."]
    }
    images = ["${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.guardrails_artifact_registry.name}/${local.guardrails_policies_container.name}:${local.guardrails_policies_container.tag}"]
  }
}

resource "google_storage_bucket" "guardrails_gcf_bucket" {
  project                     = var.project_id
  location                    = var.region
  name                        = local.cloud_storage.default_cloud_functions_archives_bucket_name
  uniform_bucket_level_access = true
  force_destroy               = true
}

data "archive_file" "guardrails_export_asset_inv_archive" {
  type        = "zip"
  source_dir  = "${path.module}/functions/${local.cloud_functions.default_export_asset_inventory_function_folder_name}"
  output_path = "${path.module}/gcf_archives/${local.cloud_functions.default_export_asset_inventory_function_name}.zip"
}

resource "google_storage_bucket_object" "guardrails_export_asset_inv_archive" {
  name   = "${local.cloud_functions.default_export_asset_inventory_function_name}.zip"
  bucket = google_storage_bucket.guardrails_gcf_bucket.name
  source = data.archive_file.guardrails_export_asset_inv_archive.output_path
}

resource "google_cloudfunctions_function" "guardrails_export_asset_inventory" {
  project     = var.project_id
  name        = local.cloud_functions.default_export_asset_inventory_function_name
  description = "Exports the organization's asset inventory"
  runtime     = "python37"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.guardrails_gcf_bucket.name
  source_archive_object = google_storage_bucket_object.guardrails_export_asset_inv_archive.name
  service_account_email = google_service_account.guardrails_service_account.email
  trigger_http          = true
  timeout               = 60
  entry_point           = "scan"
  region                = var.region

  environment_variables = {
    PARENT                     = "organizations/${var.org_id}"
    ASSET_INVENTORY_GCS_BUCKET = google_storage_bucket.guardrails_asset_inventory_bucket.name
  }
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "guardrails_export_asset_inventory_invoker" {
  project        = google_cloudfunctions_function.guardrails_export_asset_inventory.project
  region         = google_cloudfunctions_function.guardrails_export_asset_inventory.region
  cloud_function = google_cloudfunctions_function.guardrails_export_asset_inventory.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.guardrails_service_account.email}"
}

resource "google_app_engine_application" "guardrails_job_scheduler_app_egine" {
  project     = var.project_id
  location_id = var.region
}

## Cloud Scheduler - Trigger guardrails-export-asset-inventory daily
resource "google_cloud_scheduler_job" "guardrails_export_asset_job_schedule" {
  project          = var.project_id
  region           = var.region
  name             = local.cloud_scheduler.default_cloud_scheduler_name
  description      = "Triggers the export of organization asset inventory"
  schedule         = var.asset_inventory_job_schedule
  time_zone        = "America/Toronto"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.guardrails_export_asset_inventory.https_trigger_url
    body        = base64encode("{}")

    oidc_token {
      service_account_email = google_service_account.guardrails_service_account.email
    }
  }

  depends_on = [
    google_app_engine_application.guardrails_job_scheduler_app_egine
  ]
}

data "archive_file" "guardrails_run_validation" {
  type        = "zip"
  source_dir  = "${path.module}/functions/${local.cloud_functions.default_run_validation_function_folder_name}"
  output_path = "${path.module}/gcf_archives/${local.cloud_functions.default_run_validation_function_name}.zip"
}

## Cloud Function - Run Validation Scanner
resource "google_storage_bucket_object" "guardrails_run_validation" {
  name   = "${local.cloud_functions.default_run_validation_function_name}.zip"
  bucket = google_storage_bucket.guardrails_gcf_bucket.name
  source = data.archive_file.guardrails_run_validation.output_path
}

resource "google_cloudfunctions_function" "guardrails_run_validation" {
  project     = var.project_id
  name        = local.cloud_functions.default_run_validation_function_name
  description = "Triggers the guardrails validation cloud build workflow"
  runtime     = "python37"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.guardrails_gcf_bucket.name
  source_archive_object = google_storage_bucket_object.guardrails_run_validation.name
  timeout               = 60
  entry_point           = "validate"
  region                = var.region

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.guardrails_asset_inventory_bucket.name
  }

  environment_variables = {
    ORG_ID                               = var.org_id
    PROJECT_ID                           = var.project_id
    REGION                               = var.region
    GUARDRAILS_ARTIFACT_REGISTRY_NAME    = google_artifact_registry_repository.guardrails_artifact_registry.name
    REPO_NAME                            = google_sourcerepo_repository.guardrails_policies.name
    BRANCH                               = var.trigger_branch_name
    ASSET_INVENTORY_GCS_BUCKET           = google_storage_bucket.guardrails_asset_inventory_bucket.name
    GUARDRAILS_REPORTS_GCS_BUCKET        = google_storage_bucket.guardrails_reports_bucket.name
    GUARDRAILS_REPORTS_GCS_BUCKET_SUFFIX = local.suffixes.asset_inventory_reports_suffix
    GUARDRAILS_POLICIES_CONTAINER_NAME   = local.guardrails_policies_container.name
    GUARDRAILS_POLICIES_CONTAINER_TAG    = local.guardrails_policies_container.tag
  }
  depends_on = [
    google_storage_bucket_object.guardrails_run_validation
  ]
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "guardrails_run_validation_invoker" {
  project        = google_cloudfunctions_function.guardrails_run_validation.project
  region         = google_cloudfunctions_function.guardrails_run_validation.region
  cloud_function = google_cloudfunctions_function.guardrails_run_validation.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.guardrails_service_account.email}"
}
