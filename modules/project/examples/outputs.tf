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



output "project_id" {
  description = "Project id."
  value       = module.project.project_id
}

output "name" {
  description = "Project name."
  value       = module.project.name
}

output "number" {
  description = "Project number."
  value       = module.project.number
}

output "service_project_id" {
  description = "Project id."
  value       = module.service_project.project_id
}

output "project_kms_supported_service_accounts" {
  description = "Product robot service accounts in project."
  value = module.project.kms_supported_service_accounts
}

output "service_project_kms_supported_service_accounts" {
  description = "Product robot service accounts in service project."
  value = module.service_project.kms_supported_service_accounts
}
