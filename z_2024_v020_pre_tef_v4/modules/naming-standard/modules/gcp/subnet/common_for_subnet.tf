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



# WARNING - This common.tf is not symlinked to ../../common/module/common.tf
# There is override logic in this module to deal with reserved Subnet names
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
  value       = module.name_generation.result
  description = "Provides naming convention defined by the `SSC Naming and Tagging Standard for Azure` document."
}

output "result_without_type" {
  value       = module.name_generation.result_without_type
  description = "Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources."
}

output "csp_region_code" {
  value       = module.common_prefix.csp_region_code
  description = "Provides the csp_region code from the Azure location."
}
