/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Calls module gcp/generic_resource_name
# to use, set the locals: resource_type, device_type, user_defined_string

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
  description = "CSP and Region. Valid values: e = northamerica-northeast1"
}

module "generic_resource_naming" {
  source = "../../gcp/generic_resource_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  resource_type       = local.resource_type
  device_type         = local.device_type
  user_defined_string = local.user_defined_string
}

output "result" {
  value = module.generic_resource_naming.result

  description = "Provides naming convention defined by the `SSC Naming and Tagging Standard for GCP` document."
}

output "result_without_type" {
  value = module.generic_resource_naming.result_without_type

  description = "Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources."
}

output "csp_region_code" {
  value = module.generic_resource_naming.csp_region_code

  description = "Provides the csp_region code from the GCP location."
}

output "type" {
  value       = module.generic_resource_naming.type
  description = "The resource type code."
}

output "device_type" {
  value       = module.generic_resource_naming.device_type
  description = "The resource's device type code."
}

output "prefix" {
  value       = module.generic_resource_naming.prefix
  description = "The name's prefix."
}