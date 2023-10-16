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

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink
resource "google_logging_project_sink" "prod-log-sink-to-log-bucket" {
  name = var.log_sink_name
  project = var.project_id

  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project
  #destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"
  destination = "logging.googleapis.com/projects/${var.project_id}/locations/${var.region1}/buckets/${var.log_bucket_name}"
  
  #destination = "storage.googleapis.com/[GCS_BUCKET]"
  #destination = "bigquery.googleapis.com/projects/[PROJECT_ID]/datasets/[DATASET]"
  #destination = "pubsub.googleapis.com/projects/[PROJECT_ID]/topics/[TOPIC_ID]"
  #destination = "logging.googleapis.com/projects/[PROJECT_ID]/locations/global/buckets/[BUCKET_ID]"
  #destination = "logging.googleapis.com/projects/[PROJECT_ID]"

  # Example: Log all WARN or higher severity messages relating to instances
  #filter = "resource.type = gce_instance AND severity >= INFO"
  # filter only by log severity - remember filter is optional
  filter = "severity >= INFO"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_bucket_config
resource "google_logging_project_bucket_config" "prod-log-sink-bucket" {
    project          = var.project_id
    location         = var.region1
    retention_days   = 30
    #enable_analytics = true # N/A yet
    bucket_id        = var.log_bucket_name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_logging_project_sink" "prod-log-sink-to-gcs-bucket" {
  name = var.gcs_sink_name
  project = var.project_id

  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project
  #destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"
  #destination = "logging.googleapis.com/projects/${var.project_id}/locations/${var.region1}/buckets/${var.gcs_bucket_name}"
  destination = "storage.googleapis.com/${var.gcs_bucket_name}" 
  
  #destination = "storage.googleapis.com/[GCS_BUCKET]"
  #destination = "bigquery.googleapis.com/projects/[PROJECT_ID]/datasets/[DATASET]"
  #destination = "pubsub.googleapis.com/projects/[PROJECT_ID]/topics/[TOPIC_ID]"
  #destination = "logging.googleapis.com/projects/[PROJECT_ID]/locations/global/buckets/[BUCKET_ID]"
  #destination = "logging.googleapis.com/projects/[PROJECT_ID]"

  # Example: Log all WARN or higher severity messages relating to instances
  #filter = "resource.type = gce_instance AND severity >= INFO"
  # filter only by log severity - remember filter is optional
  #filter = "severity >= INFO"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}
/*
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "prod-gcs-sink-bucket" {
  name          = var.gcs_bucket_name
  location      = var.region1
  force_destroy = true
  project = var.project_id
  uniform_bucket_level_access = true
}*/