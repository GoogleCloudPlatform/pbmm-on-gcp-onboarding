/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = local.resources
}

output "name" {
  description = "names of the service perimeters"
  value       = google_access_context_manager_service_perimeter.regular_service_perimeter.name
}
