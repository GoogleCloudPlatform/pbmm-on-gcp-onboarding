/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "project_id" {
  description = "Project id."
  value       = module.project.project_id
}

output "name" {
  description = "Project name."
  value       = module.project.name
}

output "number" {
  description = "Project number."
  value       = module.project.number
}

output "service_project_id" {
  description = "Project id."
  value       = module.service_project.project_id
}
