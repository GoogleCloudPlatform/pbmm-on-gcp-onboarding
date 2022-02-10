/*
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

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

module "common_prefix" {
  source = "../../common/gc_prefix"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location
}

module "name_generation" {
  source = "../../common/name_generator"

  gc_prefix = module.common_prefix.gc_governance_prefix

  type_parent   = lookup(local.type, "parent", "")
  type          = lookup(local.type, "code", "")
  device_type   = local.device_type
  name_sections = local.name_sections
}

output "result" {
  value = module.name_generation.result

  description = "Provides naming convention result."
}


output "result_lower" {
  value = lower(module.name_generation.result)

  description = "Provides lowercase naming convention result."
}

output "result_without_type" {
  value = module.name_generation.result_without_type

  description = "Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources."
}

output "csp_region_code" {
  value = module.common_prefix.csp_region_code

  description = "Provides the csp_region code from the GCP location."
}

output "type" {
  value       = module.name_generation.type
  description = "The resource type code."
}

output "device_type" {
  value       = module.name_generation.device_type
  description = "The resource's device type code."
}

output "prefix" {
  value       = module.name_generation.prefix
  description = "The name's prefix."
}