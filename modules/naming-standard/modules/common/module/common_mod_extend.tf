/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Extend logic of a base module. Name the module 'gcp'
# For example use, refer to module/gcp/storage_account_name_generator

variable "department_code" {
  type        = string
  description = "Two character department code. Format: Uppercase lowercase e.g. Sc."
}

variable "environment" {
  type        = string
  description = "Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox"
}

variable "location" {
  type        = string
  description = "CSP and Region. Valid values: c = canadacentral, d = canadaeast"
}

output "result" {
  value       = module.gcp.result
  description = "Provides naming convention defined by the `SSC Naming and Tagging Standard for gcpure` document."
}

output "result_without_type" {
  value       = module.gcp.result_without_type
  description = "Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources."
}

output "csp_region_code" {
  value       = module.gcp.csp_region_code
  description = "Provides the csp_region code from the gcpure location."
}

output "type" {
  value       = module.gcp.type
  description = "The resource type code."
}

output "device_type" {
  value       = module.gcp.device_type
  description = "The resource's device type code."
}

output "prefix" {
  value       = module.gcp.prefix
  description = "The name's prefix."
}