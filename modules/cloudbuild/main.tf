/**
 * Copyright 2019 Google LLC
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
  gar_repo_name         = var.gar_repo_name != "" ? var.gar_repo_name : format("%s-%s", var.project_prefix, "tf-runners")
  apply_branches_regex  = "^(${join("|", var.terraform_apply_branches)})$"
  plan_branches_regex   = "[^${join("|", var.terraform_apply_branches)}]"
  gar_name              = split("/", google_artifact_registry_repository.tf-image-repo.name)[length(split("/", google_artifact_registry_repository.tf-image-repo.name)) - 1]
  terraform_sa_email    = lookup(var.terraform_sa_email, "sa")
}


/******************************************
  Cloudbuild project
*******************************************/


data "google_project" "project" {
  project_id = var.project_id
}

/******************************************
  Cloudbuild IAM for admins
*******************************************/

resource "google_project_iam_member" "org_admins_cloudbuild_editor" {
  for_each = toset(var.group_org_admins)
  project  = data.google_project.project.project_id
  role     = "roles/cloudbuild.builds.editor"
  member   = (each.value)
}

resource "google_project_iam_member" "org_admins_cloudbuild_viewer" {
  for_each = toset(var.group_org_admins)
  project  = data.google_project.project.project_id
  role     = "roles/viewer"
  member   = (each.value)
}

resource "google_project_iam_member" "group_cloudbuild_viewer" {
  for_each = toset(var.group_build_viewers)
  project  = data.google_project.project.project_id
  role     = "roles/cloudbuild.builds.viewer"
  member   = (each.value)
}

resource "google_storage_bucket_iam_member" "cloudbuild_artifacts_viewer" {
  for_each = toset(var.group_build_viewers)
  bucket   = google_storage_bucket.cloudbuild_artifacts.name
  role     = "roles/storage.objectViewer"
  member   = (each.value)
}

resource "google_project_iam_member" "cloudbuild_editor_sa" {
  project  = data.google_project.project.project_id
  role     = "roles/cloudbuild.builds.editor"
  member   = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_storage_bucket_iam_member" "cloudbuild_artifacts_viewer_sa" {
  bucket   = google_storage_bucket.cloudbuild_artifacts.name
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${local.terraform_sa_email}"
}
/******************************************
  Cloudbuild Artifact bucket
*******************************************/

resource "google_storage_bucket" "cloudbuild_artifacts" {
  project                     = data.google_project.project.project_id
  name                        = "${var.project_prefix}-cloudbuild_artifacts"
  location                    = var.default_region
  labels                      = var.storage_bucket_labels
  uniform_bucket_level_access = true
  force_destroy = true
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = var.customer_managed_key_id
  }
  logging {
    log_bucket = module.bucket_log_bucket_name.result
  }
}
/******************************************
  Cloudbuild builder bucket for logs and staging
*******************************************/

resource "google_storage_bucket" "cloudbuild_builder" {
  project                     = data.google_project.project.project_id
  name                        = "${var.project_prefix}-cloudbuild_builder"
  location                    = var.default_region
  labels                      = var.storage_bucket_labels
  uniform_bucket_level_access = true
  force_destroy               = true
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = var.customer_managed_key_id
  }
  logging {
    log_bucket = module.bucket_log_bucket_name.result
  }
}
/***********************************************
 Cloud Build - Terraform Image Repo
 ***********************************************/

resource "google_artifact_registry_repository" "tf-image-repo" {
  provider = google-beta
  project  = data.google_project.project.project_id

  location      = var.default_region
  repository_id = local.gar_repo_name
  description   = "Docker repository for Terraform runner images used by Cloud Build"
  format        = "DOCKER"
}

/***********************************************
 Cloud Build - Terraform builder
 ***********************************************/

resource "null_resource" "cloudbuild_terraform_builder" {
  triggers = {
    project_id_cloudbuild_project = data.google_project.project.project_id
    terraform_version_sha256sum   = var.terraform_version_sha256sum
    terraform_version             = var.terraform_version
    gar_name                      = local.gar_name
    gar_location                  = google_artifact_registry_repository.tf-image-repo.location
    build_file                    = md5(file("${path.module}/cloudbuild_builder/cloudbuild.yaml"))
    docker_file                   = md5(file("${path.module}/cloudbuild_builder/Dockerfile"))
  }

  provisioner "local-exec" {
    # Due to quota restrictions, cannot run builds in the default region in canada sometimes, otherwise, should add the below parameter line:
    # --region=var.default_region
    # It specifies the region of the Cloud Build Service to use. Must be set to a supported region name (e.g. us-central1). If unset, builds/region is used. If builds/region is unset,region is set to "global".
    command = <<EOT
      gcloud builds submit ${path.module}/cloudbuild_builder/ \
      --gcs-source-staging-dir=gs://${google_storage_bucket.cloudbuild_builder.name}/source \
      --gcs-log-dir=gs://${google_storage_bucket.cloudbuild_builder.name}/log \
      --project=${data.google_project.project.project_id} \
      --config=${path.module}/cloudbuild_builder/cloudbuild.yaml \
      --substitutions=_TERRAFORM_VERSION=${var.terraform_version},_TERRAFORM_VERSION_SHA256SUM=${var.terraform_version_sha256sum},_TERRAFORM_VALIDATOR_RELEASE=${var.terraform_validator_release},_REGION=${google_artifact_registry_repository.tf-image-repo.location},_REPOSITORY=${local.gar_name} \
      --async
    EOT
  }
  depends_on = [
    google_artifact_registry_repository_iam_member.terraform-image-iam
  ]
}

/***********************************************
  Cloud Build - IAM
 ***********************************************/

resource "google_storage_bucket_iam_member" "cloudbuild_artifacts_iam" {
  bucket = google_storage_bucket.cloudbuild_artifacts.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_artifact_registry_repository_iam_member" "terraform-image-iam" {
  provider = google-beta
  project  = data.google_project.project.project_id

  location   = google_artifact_registry_repository.tf-image-repo.location
  repository = google_artifact_registry_repository.tf-image-repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_service_account_iam_member" "cloudbuild_terraform_sa_impersonate_permissions" {
  for_each           = var.sa_enable_impersonation ? var.terraform_sa_email : {}
  service_account_id = "projects/${var.terraform_sa_project}/serviceAccounts/${each.value}"
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_organization_iam_member" "cloudbuild_serviceusage_consumer" {
  count = var.sa_enable_impersonation == true && var.org_id != "" ? 1 : 0

  org_id = var.org_id
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_organization_iam_member" "bootstrap_cloudbuild_builder" {
  count = var.sa_enable_impersonation == true && var.org_id != "" ? 1 : 0

  org_id = var.org_id
  role   = "roles/cloudbuild.builds.editor"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}


/*
resource "google_folder_iam_member" "cloudbuild_serviceusage_consumer" {
  count = var.sa_enable_impersonation == true && var.org_folder != "" ? 1 : 0

  folder = var.org_folder
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}*/

# Required to allow cloud build to access state with impersonation.
resource "google_storage_bucket_iam_member" "cloudbuild_state_iam" {
  for_each = var.sa_enable_impersonation ? var.terraform_state_bucket : {}
  bucket   = each.value
  role     = "roles/storage.admin"
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

/***********************************************
 Cloud Build - Pull Trigger
 ***********************************************/

resource "google_cloudbuild_trigger" "pull_request_trigger" {
  for_each = var.cloud_build_config

  name           = "${each.key}-pull-request-trigger"
  project        = data.google_project.project.project_id
  description    = "${each.key} - terraform plan on pull request to main."
  disabled       = !each.value.pull_trigger_enabled
  included_files = each.value.included_files
  ignored_files  = each.value.ignored_files

  trigger_template {
    project_id  = data.google_project.project.project_id
    repo_name   = var.cloud_source_repo_name
    branch_name = "main"
  }



  substitutions = {
    _ORG_ID               = var.org_id
    _BILLING_ID           = var.billing_account
    _DEFAULT_REGION       = var.default_region
    _GAR_REPOSITORY       = local.gar_name
    _ARTIFACT_BUCKET_NAME = google_storage_bucket.cloudbuild_artifacts.name
    _SEED_PROJECT_ID      = data.google_project.project.project_id
    _WORKSTREAM_NAME      = each.key
    _GCP_FOLDER_SUFFIX    = each.value.gcp_folder_suffix
    _WORKSTREAM_PATH      = each.value.workstream_path
    _TF_ACTION            = "plan"
    _ENV                  = basename(each.value.workstream_path)
  }

  filename = "modules/cloudbuild/templates/cloudbuild-pull-request.yaml"
}

/***********************************************
 Cloud Build - Push Trigger
 ***********************************************/

resource "google_cloudbuild_trigger" "push_request_trigger" {
  for_each = var.cloud_build_config

  name           = "${each.key}-push-trigger"
  project        = data.google_project.project.project_id
  description    = "${each.key} - terraform apply on merge to main."
  disabled       = !each.value.push_trigger_enabled
  included_files = each.value.included_files
  ignored_files  = each.value.ignored_files

  trigger_template {
    project_id  = data.google_project.project.project_id
    repo_name   = var.cloud_source_repo_name
    branch_name = "main"
  }

  substitutions = {
    _ORG_ID               = var.org_id
    _BILLING_ID           = var.billing_account
    _DEFAULT_REGION       = var.default_region
    _GAR_REPOSITORY       = local.gar_name
    _ARTIFACT_BUCKET_NAME = google_storage_bucket.cloudbuild_artifacts.name
    _SEED_PROJECT_ID      = data.google_project.project.project_id
    _WORKSTREAM_NAME      = each.key
    _GCP_FOLDER_SUFFIX    = each.value.gcp_folder_suffix
    _WORKSTREAM_PATH      = each.value.workstream_path
    _TF_ACTION            = "apply"
    _ENV                  = basename(each.value.workstream_path)
  }

  filename = "modules/cloudbuild/templates/cloudbuild-push-request.yaml"
}


