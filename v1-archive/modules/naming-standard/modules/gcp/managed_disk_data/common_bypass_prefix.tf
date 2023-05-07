/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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