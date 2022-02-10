/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  policy_id     = var.policy_id == null || var.policy_id == "" ? google_access_context_manager_access_policy.access_policy[0].id : var.policy_id
  create_policy = var.policy_id == null || var.policy_id == "" ? 1 : 0

  perimeter_services = [
    "bigtable.googleapis.com",
    "bigquery.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "dataflow.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "iaptunnel.googleapis.com",
    "logging.googleapis.com",
    "pubsub.googleapis.com",
    "servicecontrol.googleapis.com",
    "spanner.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
  ]
}