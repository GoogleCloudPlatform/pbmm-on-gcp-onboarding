/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_folder_iam_member" "folder" {
  for_each = toset(var.roles)

  role   = each.value
  folder = var.folder
  member = var.member
}