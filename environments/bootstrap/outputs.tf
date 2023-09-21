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

output "service_account_email" {
  value = module.landing_zone_bootstrap.service_account_email
}

output "tfstate_bucket_names" {
  value = { for name, bucket in module.landing_zone_bootstrap.tfstate_bucket_names :
    name => bucket
  }
}

output "project_id" {
  value = module.landing_zone_bootstrap.project_id
}

output "workerpool_id" {
  value = module.cloudbuild_bootstrap.cloudbuild_default_private_workerpool_id
}

output "organization_config" {
  value = var.organization_config
}

output "csr_name" {
  value = var.bootstrap.cloud_source_repo_name
}

output "terraform_deployment_account" {
  value = module.landing_zone_bootstrap.service_account_email
}

output "organization_active_projects" {
  value = data.google_projects.active_projects
}
