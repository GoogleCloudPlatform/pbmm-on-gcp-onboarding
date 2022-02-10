/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_project_iam_member" "role_assignment" {
  for_each = toset(var.roles)

  role    = each.value
  project = var.project
  member  = var.member
}