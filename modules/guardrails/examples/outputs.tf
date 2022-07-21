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


output "project_id" {
  description = "GCS bucket containing the asset inventory report dumps"
  value       = module.guardrails.project_id
}

output "asset_inventory_bucket" {
  description = "GCS bucket containing the asset inventory report dumps"
  value       = module.guardrails.asset_inventory_bucket
}

output "reports_bucket" {
  description = "GCS bucket containing the guardrails reports of the scan results"
  value       = module.guardrails.reports_bucket
}

output "report_generation_schedule" {
  description = "The schedule of the report generation."
  value       = module.guardrails.report_generation_schedule
}

output "guardrails_validation_container_location" {
  value = module.guardrails.guardrails_container_location
}

output "cloudbuild_container_pipeline_trigger" {
  value = module.guardrails.cloudbuild_container_pipeline_trigger[0]
}

output "guardrails_policies_repo_name" {
  value = module.guardrails.guardrails_policies_repo_name
}
