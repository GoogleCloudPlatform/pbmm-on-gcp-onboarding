/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_access_context_manager_access_policy" "access_policy" {
  count  = local.create_policy
  parent = "organizations/${var.parent_id}"
  title  = module.policy_name.result
}

module "access_level" {
  source                           = "./modules/access_level"
  for_each                         = var.access_level
  policy                           = local.policy_id
  name                             = module.access_list_names[each.key].result
  description                      = lookup(each.value, "description", "")
  ip_subnetworks                   = lookup(each.value, "ip_subnetworks", null) == null ? [] : each.value.ip_subnetworks
  required_access_levels           = lookup(each.value, "required_access_levels", null) == null ? [] : each.value.required_access_levels
  members                          = lookup(each.value, "members", null) == null ? [] : each.value.members
  negate                           = lookup(each.value, "negate", null) == null ? false : each.value.negate
  regions                          = lookup(each.value, "regions", null) == null ? [] : each.value.regions
  require_screen_lock              = lookup(each.value, "require_screen_lock", null) == null ? false : each.value.require_screen_lock
  allowed_encryption_statuses      = lookup(each.value, "allowed_encryption_statuses", null) == null ? [] : each.value.allowed_encryption_statuses
  allowed_device_management_levels = lookup(each.value, "allowed_device_management_levels", null) == null ? [] : each.value.allowed_device_management_levels
  require_corp_owned               = lookup(each.value, "require_corp_owned", null) == null ? false : each.value.require_screen_lock
  minimum_version                  = lookup(each.value, "minimum_version", null) == null ? "" : each.value.minimum_version
  os_type                          = lookup(each.value, "os_type", null) == null ? "OS_UNSPECIFIED" : each.value.os_type
  combining_function               = lookup(each.value, "combining_function", null) == null ? "AND" : each.value.combining_function
}

module "regular_service_perimeter" {
  source                       = "./modules/regular_service_perimeter"
  for_each                     = var.regular_service_perimeter
  policy                       = local.policy_id
  perimeter_name               = module.regular_service_perimeter_names[each.key].result
  description                  = lookup(each.value, "description", null) == null ? "" : each.value.description
  restricted_services          = lookup(each.value, "restricted_services", null) == null ? local.perimeter_services : each.value.restricted_services
  resources                    = lookup(each.value, "resources", null) == null ? [] : each.value.resources
  resources_by_numbers         = lookup(each.value, "resources_by_numbers", null) == null ? [] : each.value.resources_by_numbers
  access_levels                = lookup(each.value, "access_levels", null) == null ? [] : each.value.access_levels
  restricted_services_dry_run  = lookup(each.value, "restricted_services_dry_run", null) == null ? local.perimeter_services : each.value.restricted_services_dry_run
  resources_dry_run            = lookup(each.value, "resources_dry_run", null) == null ? [] : each.value.resources_dry_run
  resources_dry_run_by_numbers = lookup(each.value, "resources_dry_run_by_numbers", null) == null ? [] : each.value.resources_dry_run_by_numbers
  access_levels_dry_run        = lookup(each.value, "access_levels_dry_run", null) == null ? [] : each.value.access_levels_dry_run
  vpc_accessible_services      = lookup(each.value, "vpc_accessible_services", null) == null ? null : each.value.vpc_accessible_services
  live_run                     = lookup(each.value, "live_run", null) == null ? false : each.value.live_run
  dry_run                      = lookup(each.value, "dry_run", null) == null ? false : each.value.dry_run
  depends_on                   = [module.access_level]
}

module "bridge_service_perimeter" {
  source                       = "./modules/bridge_service_perimeter"
  for_each                     = var.bridge_service_perimeter
  policy                       = local.policy_id
  perimeter_name               = module.bridge_service_perimeter_names[each.key].result
  description                  = lookup(each.value, "description", null) == null ? "" : each.value.description
  resources                    = lookup(each.value, "resources", null) == null ? [] : each.value.resources
  resources_by_numbers         = lookup(each.value, "resources_by_numbers", null) == null ? [] : each.value.resources_by_numbers
  resources_dry_run            = lookup(each.value, "resources_dry_run", null) == null ? [] : each.value.resources_dry_run
  resources_dry_run_by_numbers = lookup(each.value, "resources_dry_run_by_numbers", null) == null ? [] : each.value.resources_dry_run_by_numbers
  live_run                     = lookup(each.value, "live_run", null) == null ? false : each.value.live_run
  dry_run                      = lookup(each.value, "dry_run", null) == null ? false : each.value.dry_run
  depends_on                   = [module.regular_service_perimeter]
}
