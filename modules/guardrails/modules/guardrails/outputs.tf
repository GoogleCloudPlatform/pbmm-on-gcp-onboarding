/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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