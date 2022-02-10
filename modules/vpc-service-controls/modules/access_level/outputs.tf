/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  value       = split("/", local.output_name)[3]
}

output "name_id" {
  description = "The fully-qualified name of the Access Level. Format: accessPolicies/{policy_id}/accessLevels/{name}"
  value       = local.output_name
}
