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

module "monitoring_center_project" {
  count                          = var.project == null || var.project == "" ? 1 : 0
  source                         = "../project"
  department_code                = var.department_code
  environment                    = var.environment
  location                       = var.location
  owner                          = var.owner
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
  parent                         = var.parent
  billing_account                = var.billing_account
  tf_service_account_email       = var.tf_service_account_email
  labels                         = var.projectlabels
  services                       = ["monitoring.googleapis.com", "logging.googleapis.com"]
}

resource "google_project_iam_member" "monitoring_viewer_member" {
  for_each = toset(var.monitoring_viewer_members_list)
  project  = local.scoping_project_id
  role     = "roles/monitoring.viewer"
  member   = each.value
depends_on = [module.monitoring_center_project]
}

resource "google_monitoring_monitored_project" "monitored_projects" {
  provider      = google-beta
  for_each      = local.filtered_monitored_projects
  metrics_scope = "locations/global/metricsScopes/${local.scoping_project_id}"
  name          = "locations/global/metricsScopes/${local.scoping_project_id}/projects/${each.value.project_id}"
  depends_on = [module.monitoring_center_project]
}
