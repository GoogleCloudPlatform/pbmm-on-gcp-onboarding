/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "role_ids" {
  value = { for name, role in google_organization_iam_custom_role.org_custom_role :
    name => role.role_id
  }
}