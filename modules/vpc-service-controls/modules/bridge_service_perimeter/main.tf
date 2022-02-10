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
}

data "google_project" "resources" {
  for_each   = toset(var.resources)
  project_id = each.value
}

resource "google_access_context_manager_service_perimeter" "bridge_service_perimeter" {
  provider       = google
  parent         = "accessPolicies/${var.policy}"
  perimeter_type = "PERIMETER_TYPE_BRIDGE"
  name           = "accessPolicies/${var.policy}/servicePerimeters/${var.perimeter_name}"
  title          = var.perimeter_name

  dynamic "status" {
    for_each = length(local.resources) > 0 ? ["status"] : []
    content {
      resources = formatlist("projects/%s", local.resources)
    }
  }
  lifecycle {
    ignore_changes = [status[0].resources]
  }
}
