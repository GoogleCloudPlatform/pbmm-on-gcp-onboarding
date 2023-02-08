/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
