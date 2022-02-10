/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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

output "report_generation_schedule" {
  description = "The schedule of the report generation."
  value       = module.guardrails[0].report_generation_schedule
}

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