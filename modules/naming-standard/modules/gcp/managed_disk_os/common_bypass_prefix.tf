/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "name_generation" {
  source = "../../common/name_generator"

  gc_prefix = ""

  type_parent   = lookup(local.type, "parent", "")
  type          = lookup(local.type, "code", "")
  device_type   = local.device_type
  name_sections = local.name_sections
}

output "result" {
  value = module.name_generation.result

  description = "Provides naming convention."
}

output "result_lower" {
  value = lower(module.name_generation.result)

  description = "Provides lowercase naming convention."
}

output "result_without_type" {
  value = module.name_generation.result_without_type

  description = "Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources."
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