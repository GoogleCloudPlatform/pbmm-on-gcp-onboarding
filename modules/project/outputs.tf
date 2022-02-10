/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "project_id" {
  description = "Project id."
  value       = try(google_project.project.project_id, null)
  depends_on = [
    google_project_organization_policy.boolean,
    google_project_organization_policy.list,
    google_project_service.project_services,
  ]
}

output "name" {
  description = "Project name."
  value       = google_project.project.name
  depends_on = [
    google_project_organization_policy.boolean,
    google_project_organization_policy.list,
    google_project_service.project_services,
  ]
}

output "number" {
  description = "Project number."
  value       = google_project.project.number
  depends_on = [
    google_project_organization_policy.boolean,
    google_project_organization_policy.list,
    google_project_service.project_services,
  ]
}

output "service_accounts" {
  description = "Product robot service accounts in project."
  value = {
    cloud_services = local.service_account_cloud_services
    default        = local.service_accounts_default
    robots         = local.service_accounts_robots
  }
  depends_on = [google_project_service.project_services]
}