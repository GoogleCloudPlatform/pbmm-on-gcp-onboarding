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

module "audit_project" {
  source                         = "../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
  labels                         = local.labels
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.region
  parent                         = var.parent
  tf_service_account_email       = var.tf_service_account_email
  services = [
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "accesscontextmanager.googleapis.com"
  ]
}

module "audit" {
  for_each = var.audit_streams
  source   = "./modules/audit"

  project_id = module.audit_project.project_id
  org_id     = var.org_id
  region     = var.region

  bucket_name                    = each.value.bucket_name
  sink_name                      = each.value.sink_name
  description                    = each.value.description
  filter                         = each.value.filter
  labels                         = each.value.labels
  is_locked                      = each.value.is_locked
  retention_period               = each.value.retention_period
  bucket_viewer                  = each.value.bucket_viewer
  force_destroy                  = each.value.bucket_force_destroy
  storage_class                  = each.value.bucket_storage_class
  customer_managed_key_id        = module.audit_project.default_regional_customer_managed_key_id
  environment                    = var.environment
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
}

resource "google_logging_billing_account_sink" "billing-sink" {
  name            = var.sink_name
  description     = "Sink for all Billing accounts"
  billing_account = var.billing_account

  # Can export to pubsub, cloud storage, or bigquery
  destination = "storage.googleapis.com/${google_storage_bucket.billing-log-bucket.name}"
}

resource "google_storage_bucket" "billing-log-bucket" {
  name                        = module.billing_log_bucket_name.result
  project                     = module.audit_project.project_id
  location                    = var.region
  labels                      = var.labels
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = module.audit_project.default_regional_customer_managed_key_id
  }
  /*  description                  = var.description
  is_locked                      = var.is_locked
  retention_period               = var.retention_period
  filter                         = var.filter  */
  force_destroy = true       #var.bucket_force_destroy
  storage_class = "STANDARD" #var.bucket_storage_class #

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
}

resource "google_project_iam_member" "log_writer_member" {
  role    = "roles/storage.objectCreator"
  project = module.audit_project.project_id
  member  = google_logging_billing_account_sink.billing-sink.writer_identity
}

resource "google_service_account" "billing_service_account" {
  account_id   = "billing-service-account"
  display_name = "Service Account for the Billing projects"
  project      = module.audit_project.project_id
}

resource "google_project_iam_member" "billing_iam_member" {
  project = module.audit_project.project_id
  role    = "roles/logging.viewAccessor"
  member  = "serviceAccount:${google_service_account.billing_service_account.email}"
}

resource "google_storage_bucket" "bucket_log_bucket" {
  name                        = module.bucket_log_bucket_name.result
  project                     = module.audit_project.project_id
  location                    = var.region
  labels                      = var.labels
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = module.audit_project.default_regional_customer_managed_key_id
  }
  /*  description                  = var.description
  is_locked                      = var.is_locked
  retention_period               = var.retention_period
  filter                         = var.filter  */
  force_destroy = true       #var.bucket_force_destroy
  storage_class = "STANDARD" #var.bucket_storage_class #

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
}

resource "google_service_account" "bucketlog_service_account" {
  account_id   = "bucketlog-service-account"
  display_name = "Service Account for the bucket log projects"
  project      = module.audit_project.project_id
}

resource "google_project_iam_member" "bucketlog_iam_member" {
  project = module.audit_project.project_id
  role    = "roles/logging.viewAccessor"
  member  = "serviceAccount:${google_service_account.bucketlog_service_account.email}"
}

resource "google_storage_bucket_iam_member" "bucketlog_bucketwriter_iam_member" {
  bucket = google_storage_bucket.bucket_log_bucket.name
  role   = "roles/storage.legacyBucketWriter"
  member = "group:cloud-storage-analytics@google.com"
}
