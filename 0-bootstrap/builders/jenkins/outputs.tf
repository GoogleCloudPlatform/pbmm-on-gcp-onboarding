/**
 * Copyright 2021 Google LLC
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

output "seed_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.seed_bootstrap.seed_project_id
}

output "bootstrap_step_terraform_service_account_email" {
  description = "Bootstrap Step Terraform Account"
  value       = google_service_account.terraform-env-sa["bootstrap"].email
}

output "projects_step_terraform_service_account_email" {
  description = "Projects Step Terraform Account"
  value       = google_service_account.terraform-env-sa["proj"].email
}

output "networks_step_terraform_service_account_email" {
  description = "Networks Step Terraform Account"
  value       = google_service_account.terraform-env-sa["net"].email
}

output "environment_step_terraform_service_account_email" {
  description = "Environment Step Terraform Account"
  value       = google_service_account.terraform-env-sa["env"].email
}

output "organization_step_terraform_service_account_email" {
  description = "Organization Step Terraform Account"
  value       = google_service_account.terraform-env-sa["org"].email
}

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for Foundations Pipelines in Seed Project."
  value       = module.seed_bootstrap.gcs_bucket_tfstate
}

output "common_config" {
  description = "Common configuration data to be used in other steps."
  value = {
    org_id                = var.org_id,
    parent_folder         = var.parent_folder,
    billing_account       = var.billing_account,
    default_region        = var.default_region,
    project_prefix        = var.project_prefix,
    folder_prefix         = var.folder_prefix
    parent_id             = local.parent
    bootstrap_folder_name = google_folder.bootstrap.name
  }
}

output "required_groups" {
  description = "List of Google Groups created that are required by the Example Foundation steps."
  value       = var.groups.create_required_groups == false ? tomap(var.groups.required_groups) : tomap({ for key, value in module.required_group : key => value.id })
}

output "optional_groups" {
  description = "List of Google Groups created that are optional to the Example Foundation steps."
  value       = var.groups.create_optional_groups == false ? tomap(var.groups.optional_groups) : tomap({ for key, value in module.optional_group : key => value.id })
}

/* ----------------------------------------
    Specific to jenkins_bootstrap module
   ---------------------------------------- */
# # Un-comment the jenkins_bootstrap module and its outputs if you want to use Jenkins instead of Cloud Build
output "cicd_project_id" {
  description = "Project where the [CI/CD Pipeline](/docs/GLOSSARY.md#foundation-cicd-pipeline) (Jenkins Agents and terraform builder container image) reside."
  value       = module.jenkins_bootstrap.cicd_project_id
}
output "jenkins_agent_gce_instance_id" {
  description = "Jenkins Agent GCE Instance id."
  value       = module.jenkins_bootstrap.jenkins_agent_gce_instance_id
}
output "jenkins_agent_vpc_id" {
  description = "Jenkins Agent VPC name."
  value       = module.jenkins_bootstrap.jenkins_agent_vpc_id
}
output "projects_gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for stage 4-projects foundations pipelines in seed project."
  value       = module.seed_bootstrap.gcs_bucket_tfstate
}
output "jenkins_agent_sa_email" {
  description = "Email for privileged custom service account for Jenkins Agent GCE instance."
  value       = module.jenkins_bootstrap.jenkins_agent_sa_email
}
output "jenkins_agent_sa_name" {
  description = "Fully qualified name for privileged custom service account for Jenkins Agent GCE instance."
  value       = module.jenkins_bootstrap.jenkins_agent_sa_name
}
output "gcs_bucket_jenkins_artifacts" {
  description = "Bucket used to store Jenkins artifacts in Jenkins project."
  value       = module.jenkins_bootstrap.gcs_bucket_jenkins_artifacts
}
