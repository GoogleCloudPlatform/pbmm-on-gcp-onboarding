/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  parent_type   = var.parent == null ? null : split("/", var.parent)[0]
  parent_id     = var.parent == null ? null : split("/", var.parent)[1]
  create_roles  = var.tf_service_account_email == null || var.tf_service_account_email == "" ? false : true
  project_roles = [
    "roles/source.admin",
    "roles/secretmanager.secretAccessor",
    "roles/resourcemanager.projectMover",
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin",
  ]
}