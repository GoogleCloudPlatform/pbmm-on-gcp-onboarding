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

resource "google_storage_bucket" "audit_bucket" {
  project                     = var.project_id
  name                        = module.audit_streams_bucket_name.result
  location                    = var.region
  labels                      = var.labels
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy
  storage_class               = var.storage_class
  encryption {
    default_kms_key_name = var.customer_managed_key_id
  }

  retention_policy {
    is_locked        = var.is_locked
    retention_period = var.retention_period
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
        type = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition {
        age        = 180
        with_state = "ANY"
      }
  } 
}

resource "google_logging_organization_sink" "audit_sink" {
  name             = module.log_sink_name.result
  description      = var.description
  org_id           = var.org_id
  include_children = true
  destination      = "storage.googleapis.com/${google_storage_bucket.audit_bucket.name}"
  filter           = var.filter
}

resource "google_storage_bucket_iam_member" "log-writer" {
  bucket = google_storage_bucket.audit_bucket.name
  role   = "roles/storage.objectCreator"
  member = google_logging_organization_sink.audit_sink.writer_identity
}

resource "google_storage_bucket_iam_member" "log-reader" {
  bucket = google_storage_bucket.audit_bucket.name
  role   = "roles/storage.objectViewer"
  member = var.bucket_viewer
}