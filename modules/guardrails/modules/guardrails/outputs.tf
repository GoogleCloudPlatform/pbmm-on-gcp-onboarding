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



output "asset_inventory_bucket" {
  description = "GCS bucket containing the asset inventory report dumps"
  value       = google_storage_bucket.guardrails_asset_inventory_bucket.name
}

output "reports_bucket" {
  description = "GCS bucket containing the guardrails reports of the scan results"
  value       = google_storage_bucket.guardrails_reports_bucket.name
}

output "report_generation_schedule" {
  description = "The schedule of the report generation."
  value       = google_cloud_scheduler_job.guardrails_export_asset_job_schedule.schedule
}

output "cloudbuild_container_pipeline_definition" {
  description = "The Cloud Build pipeline definition that builds the report generation container"
  value       = google_cloudbuild_trigger.guardrails_build_docker.build[0]
}

output "cloudbuild_container_pipeline_trigger" {
  description = "The Cloud Build Trigger that builds the report generation container"
  value       = google_cloudbuild_trigger.guardrails_build_docker.trigger_template
}

output "guardrails_policies_repo_name" {
  description = "The name of the repository containing the guardrails rego policies in Cloud Source Repository"
  value       = google_sourcerepo_repository.guardrails_policies.name
}