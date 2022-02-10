/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_storage_bucket" "audit_bucket" {
  project                     = var.project_id
  name                        = module.audit_streams_bucket_name.result
  location                    = var.region
  labels                      = var.labels
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy
  storage_class               = var.storage_class
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