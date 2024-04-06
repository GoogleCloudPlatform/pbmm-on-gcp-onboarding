/**
 * Copyright 2023 Google LLC
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
  scoping_project_id          = (var.project == null || var.project == "") ? try(module.monitoring_center_project[0].project_id, null) : var.project
  scoping_project_parent_id   = try(split("/", var.parent)[1], null)
  matched_monitored_projects  = local.scoping_project_id == null || local.scoping_project_parent_id == null ? [] : try(var.monitored_projects, [])
  filtered_monitored_projects = { for prj in local.matched_monitored_projects : prj.project_id => prj if prj.parent.id != local.scoping_project_parent_id && prj.project_id != local.scoping_project_id }
}
