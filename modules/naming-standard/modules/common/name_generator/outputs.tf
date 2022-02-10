/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# name
output "result" {
  value = local.name
}

# name without type
output "result_without_type" {
  value = replace(local.name, "/${local.name_without_type_replacement}$/", "")
}

output "type" {
  value       = local.type
  description = "The resource type code."
}

output "device_type" {
  value       = local.device_type
  description = "The resource's device type code."
}

output "prefix" {
  value       = local.prefix
  description = "The name's prefix."
}