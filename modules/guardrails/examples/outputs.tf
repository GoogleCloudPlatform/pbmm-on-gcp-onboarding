/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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
