/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  platform_roles = merge(
    local.application_roles,
    local.network_administrator_roles,
    local.security_operator_roles,
    local.platform_operator_roles,
    local.domain_administrator_role,
    local.read_only_roles,
    local.billing_administrator_role,
    local.billing_operations_role,
    local.billing_viewonly_role,
    var.custom_roles,
  )
}