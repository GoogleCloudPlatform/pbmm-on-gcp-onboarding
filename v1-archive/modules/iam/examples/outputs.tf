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



output "service_accounts" {
  value = module.iam.service_accounts
}

output "project_iam_members" {
  value = module.iam.project_iam_members
}

output "compute_network_users" {
  value = module.iam.compute_network_users
}

output "folder_iam_members" {
  value = module.iam.folder_iam_members
}

output "organization_iam_members" {
  value = module.organization_iam.organization_iam_members
}

