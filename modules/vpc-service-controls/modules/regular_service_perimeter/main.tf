/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  resources = length(var.resources) > 0 && length(var.resources_by_numbers) == 0 ? flatten([
    for project in var.resources :
    data.google_project.resources[project].number
  ]) : var.resources_by_numbers

  resources_dry_run = length(var.resources_dry_run) > 0 && length(var.resources_dry_run_by_numbers) == 0 ? flatten([
    for project in var.resources_dry_run :
    data.google_project.resources[project].number
  ]) : var.resources_dry_run_by_numbers
}

data "google_project" "resources" {
  for_each   = toset(var.resources)
  project_id = each.value
}

data "google_project" "resources_dry_run" {
  for_each   = toset(var.resources_dry_run)
  project_id = each.value
}

resource "google_access_context_manager_service_perimeter" "regular_service_perimeter" {
  provider       = google
  parent         = "accessPolicies/${var.policy}"
  perimeter_type = "PERIMETER_TYPE_REGULAR"
  name           = "accessPolicies/${var.policy}/servicePerimeters/${var.perimeter_name}"
  title          = var.perimeter_name
  description    = var.description

  dynamic "status" {
    for_each = var.live_run ? ["live_run"] : []
    content {
      restricted_services = var.restricted_services
      resources           = formatlist("projects/%s", local.resources)
      access_levels = formatlist(
        "accessPolicies/${var.policy}/accessLevels/%s",
        var.access_levels
      )
      dynamic "vpc_accessible_services" {
        for_each = var.vpc_accessible_services != null ? ["vpc"] : []
        content {
          enable_restriction = var.vpc_accessible_services.enable_restriction
          allowed_services   = var.vpc_accessible_services.enable_restriction ? toset(var.vpc_accessible_services.allowed_services) : null
        }
      }
    }
  }

  dynamic "spec" {
    for_each = var.dry_run ? ["dry-run"] : []
    content {
      restricted_services = var.restricted_services_dry_run
      resources           = formatlist("projects/%s", local.resources_dry_run)
      access_levels = formatlist(
        "accessPolicies/${var.policy}/accessLevels/%s",
        var.access_levels_dry_run
      )
      dynamic "vpc_accessible_services" {
        for_each = var.vpc_accessible_services != null ? ["vpc"] : []
        content {
          enable_restriction = var.vpc_accessible_services.enable_restriction
          allowed_services   = var.vpc_accessible_services.enable_restriction ? toset(var.vpc_accessible_services.allowed_services) : null
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [status[0].resources]
  }
  use_explicit_dry_run_spec = var.dry_run
}
