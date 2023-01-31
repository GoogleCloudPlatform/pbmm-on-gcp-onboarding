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
  description = "The Project ID of the guardrails resources have been deployed to"
  value       = module.guardrails_project.project_id
}

output "asset_inventory_bucket" {
  description = "GCS bucket containing the asset inventory report dumps"
  value       = module.guardrails[0].asset_inventory_bucket
}

output "reports_bucket" {
  description = "GCS bucket containing the guardrails reports of the scan results"
  value       = module.guardrails[0].reports_bucket
}

/*output "report_generation_schedule" {
  description = "The schedule of the report generation."
  value       = module.guardrails[0].report_generation_schedule
}*/

output "cloudbuild_container_pipeline_definition" {
  description = "The Cloud Build Trigger that builds the report generation container"
  value       = module.guardrails[0].cloudbuild_container_pipeline_definition
}

output "cloudbuild_container_pipeline_trigger" {
  description = "The Cloud Build Trigger that builds the report generation container"
  value       = module.guardrails[0].cloudbuild_container_pipeline_trigger
}

output "guardrails_container_location" {
  description = "The Cloud Build Trigger that builds the report generation container"
  value       = module.guardrails[0].cloudbuild_container_pipeline_definition.images[0]
}

output "guardrails_policies_repo_name" {
  description = "The name of the repository containing the guardrails rego policies in Cloud Source Repository"
  value       = module.guardrails[0].guardrails_policies_repo_name
}