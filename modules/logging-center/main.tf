/**
 * Copyright 2023 Google LLC
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

module "logging_center_project" {
  source                         = "../project"
  department_code                = var.department_code
  environment                    = var.environment
  location                       = var.location
  owner                          = var.owner
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
  parent                         = var.parent
  billing_account                = var.billing_account
  tf_service_account_email       = var.tf_service_account_email
  labels                         = var.projectlabels
  services                       = ["storage.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
}

resource "null_resource" "project_creation_waiting" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 60
    EOT
  }
  depends_on = [
    module.logging_center_project
  ]
}

data "google_logging_project_cmek_settings" "cmek_settings" {
  provider = google-beta
  project  = module.logging_center_project.project_id
  depends_on = [
    null_resource.project_creation_waiting
  ]
}

resource "google_kms_crypto_key_iam_member" "cryptokey_encrypterdecrypter_member" {
  count         = data.google_logging_project_cmek_settings.cmek_settings.service_account_id != null ? 1 : 0
  crypto_key_id = module.logging_center_project.default_regional_customer_managed_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_logging_project_cmek_settings.cmek_settings.service_account_id}"
}

resource "null_resource" "iam_propagation_waiting" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 30
    EOT
  }
  depends_on = [
    google_kms_crypto_key_iam_member.cryptokey_encrypterdecrypter_member
  ]
}

resource "google_logging_project_bucket_config" "simple_central_logs_bucket" {
  provider       = google-beta
  project        = module.logging_center_project.project_id
  location       = var.simple_central_log_bucket.location == "" ? var.location : var.simple_central_log_bucket.location
  bucket_id      = "${var.simple_central_log_bucket.name}-bucket"
  description    = var.simple_central_log_bucket.description
  retention_days = var.simple_central_log_bucket.retention_days
  cmek_settings {
    kms_key_name = module.logging_center_project.default_regional_customer_managed_key_id
  }
  depends_on = [
    google_kms_crypto_key_iam_member.cryptokey_encrypterdecrypter_member,
    null_resource.iam_propagation_waiting
  ]
}

resource "google_project_iam_member" "simple_central_logs_bucket_viewer_member" {
  for_each = toset(var.log_bucket_viewer_members_list)
  project  = module.logging_center_project.project_id
  role     = "roles/logging.viewAccessor"
  member   = each.value
}

resource "google_logging_organization_sink" "simple_organization_aggregated_sink" {
  count            = var.simple_central_log_bucket.source_organization_sink != null ? 1 : 0
  name             = "${var.simple_central_log_bucket.name}-org-sink"
  description      = "A sink to aggregate logs within the given organization, inlcuding logs from billing accounts, projects, folders and the organization root, to a central logs bucket."
  org_id           = var.simple_central_log_bucket.source_organization_sink.organization_id
  include_children = var.simple_central_log_bucket.source_organization_sink.include_children
  destination      = "logging.googleapis.com/${google_logging_project_bucket_config.simple_central_logs_bucket.id}"
  filter           = var.simple_central_log_bucket.source_organization_sink.inclusion_filter
  disabled         = var.simple_central_log_bucket.source_organization_sink.disabled
}

resource "google_project_iam_member" "simple_organization_aggregated_sink_logging_bucket_writer" {
  count   = var.simple_central_log_bucket.source_organization_sink != null ? 1 : 0
  project = module.logging_center_project.project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.simple_organization_aggregated_sink[0].writer_identity
}

resource "google_logging_folder_sink" "simple_folder_aggregated_sink" {
  count            = var.simple_central_log_bucket.source_folder_sink != null ? 1 : 0
  name             = "${var.simple_central_log_bucket.name}-folder-sink"
  description      = "A sink to aggregate logs from projects under the given folder to a central logs bucket."
  folder           = var.simple_central_log_bucket.source_folder_sink.folder
  include_children = var.simple_central_log_bucket.source_folder_sink.include_children
  destination      = "logging.googleapis.com/${google_logging_project_bucket_config.simple_central_logs_bucket.id}"
  filter           = var.simple_central_log_bucket.source_folder_sink.inclusion_filter
  disabled         = var.simple_central_log_bucket.source_folder_sink.disabled
}

resource "google_project_iam_member" "simple_folder_aggregated_sink_logging_bucket_writer" {
  count   = var.simple_central_log_bucket.source_folder_sink != null ? 1 : 0
  project = module.logging_center_project.project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_folder_sink.simple_folder_aggregated_sink[0].writer_identity
}

resource "google_storage_bucket" "simple_log_destination_bucket" {
  count                       = var.simple_central_log_bucket.exporting_project_sink != null ? 1 : 0
  project                     = var.simple_central_log_bucket.exporting_project_sink.destination_project
  name                        = var.simple_central_log_bucket.exporting_project_sink.destination_bucket
  location                    = var.simple_central_log_bucket.exporting_project_sink.destination_bucket_location == "" ? var.location : var.simple_central_log_bucket.exporting_project_sink.destination_bucket_location
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = format("projects/%s/locations/%s/keyRings/default-regional-key-ring/cryptoKeys/default-regional-customer-managed-key", var.simple_central_log_bucket.exporting_project_sink.destination_project, var.simple_central_log_bucket.exporting_project_sink.destination_bucket_location == "" ? var.location : var.simple_central_log_bucket.exporting_project_sink.destination_bucket_location)
  }
  force_destroy = true
  storage_class = "STANDARD"
  retention_policy {
    is_locked        = false
    retention_period = var.simple_central_log_bucket.exporting_project_sink.retention_period
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 365
      with_state = "ANY"
    }
  }
  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition {
      age        = 180
      with_state = "ANY"
    }
  }
  
  depends_on = [
    null_resource.project_creation_waiting
  ]
}

resource "google_logging_project_sink" "simple_export_to_storage_bucket_sink" {
  count                  = var.simple_central_log_bucket.exporting_project_sink != null ? 1 : 0
  project                = module.logging_center_project.project_id
  name                   = "export-to-${google_storage_bucket.simple_log_destination_bucket[0].name}-sink"
  description            = "Export logs to storage bucket ${google_storage_bucket.simple_log_destination_bucket[0].name}"
  destination            = "storage.googleapis.com/${google_storage_bucket.simple_log_destination_bucket[0].name}"
  filter                 = var.simple_central_log_bucket.exporting_project_sink.inclusion_filter
  unique_writer_identity = var.simple_central_log_bucket.exporting_project_sink.unique_writer_identity
  disabled               = var.simple_central_log_bucket.exporting_project_sink.disabled
}

resource "google_project_iam_member" "simple_bucket_log_writer_member" {
  count   = var.simple_central_log_bucket.exporting_project_sink != null ? 1 : 0
  project = var.simple_central_log_bucket.exporting_project_sink.destination_project
  role    = "roles/storage.objectCreator"
  member  = google_logging_project_sink.simple_export_to_storage_bucket_sink[0].writer_identity
}
