/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_project_iam_member" "role_assignment" {
  for_each = toset(var.roles)

  role    = each.value
  project = var.project
  member  = "serviceAccount:${google_service_account.service_account.email}"
}