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