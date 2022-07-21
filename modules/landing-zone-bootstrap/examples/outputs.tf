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


output "tfstate_bucket_names" {
  value = module.bootstrap_project.tfstate_bucket_names
}

output "project_id" {
  value = module.bootstrap_project.project_id
}

output "service_account_email" {
  value = module.bootstrap_project.service_account_email
}

output "yaml_config_bucket" {
  value = module.bootstrap_project.yaml_config_bucket
}