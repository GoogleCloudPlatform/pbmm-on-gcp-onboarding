/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_organization_iam_member" "organization" {
  for_each = toset(var.roles)

  role   = each.value
  org_id = var.organization
  member = var.member
}