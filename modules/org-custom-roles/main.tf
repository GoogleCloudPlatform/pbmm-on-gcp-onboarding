/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_organization_iam_custom_role" "org_custom_role" {
  for_each    = local.platform_roles
  role_id     = module.custom_role_names[each.key].result
  org_id      = var.org_id
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
}
