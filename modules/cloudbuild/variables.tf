
/**
 * Copyright 2019 Google LLC
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

/******************************************
  Required variables
*******************************************/

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "org_folder" {
  description = "GCP top-level folder for IAM binding"
  type        = string
}

variable "project_create" {
  description = "Boolean to determine if a new project should be created"
  type        = bool
  default     = true
}


variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "group_org_admins" {
  description = "List of IAM entities for GCP Organization Administrators"
  type        = list(string)
}

variable "group_build_viewers" {
  description = "List of IAM entities able to view Cloud Build output."
  type        = list(string)
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
  default     = "northamerica-northeast1"
}

variable "terraform_sa_email" {
  description = "Email for terraform service account."
  type        = map(string)
}

variable "terraform_state_bucket" {
  description = "Terraform state bucket, used in Cloud Build substitutions for each environment."
  type        = map(string)
}

variable "terraform_sa_project" {
  description = "GCP Project where the Terraform Service Account(s) exist"
  type        = string
}

/******************************************
  Optional variables
*******************************************/

variable "project_labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default     = {}
}

variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "cft"
}

variable "project_id" {
  description = "Custom project ID to use for project created."
  default     = ""
  type        = string
}

variable "customer_managed_key_id" {
  description = "Customer managed key id."
  default     = ""
  type        = string
}

variable "activate_apis" {
  description = "List of APIs to enable in the Cloudbuild project."
  type        = list(string)

  default = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com"
  ]
}

variable "sa_enable_impersonation" {
  description = "Allow org_admins group to impersonate service account & enable APIs required."
  type        = bool
  default     = false
}

variable "storage_bucket_labels" {
  description = "Labels to apply to the storage bucket."
  type        = map(string)
  default     = {}
}


variable "cloud_source_repo_name" {
  description = "Name of Cloud Source Repo used for the triggers"
  type        = string
}

variable "parent" {
  description = "The parent of the project for cloud build to be hosted in. Either organizations/############ or folders/<folder>"
  type        = string
  default     = ""
}

variable "terraform_version" {
  description = "Default terraform version."
  type        = string
  default     = "1.0.10"
}

variable "terraform_version_sha256sum" {
  description = "sha256sum for default terraform version."
  type        = string
  default     = "a221682fcc9cbd7fde22f305ead99b3ad49d8303f152e118edda086a2807716d"
}

variable "terraform_validator_release" {
  description = "Default terraform-validator release."
  type        = string
  default     = "2021-03-22"
}

variable "cloudbuild_plan_filename" {
  description = "Path and name of Cloud Build YAML definition used for terraform plan."
  type        = string
  default     = "cloudbuild-tf-plan.yaml"
}

variable "cloudbuild_apply_filename" {
  description = "Path and name of Cloud Build YAML definition used for terraform apply."
  type        = string
  default     = "cloudbuild-tf-apply.yaml"
}

variable "terraform_apply_branches" {
  description = "List of git branches configured to run terraform apply Cloud Build trigger. All other branches will run plan by default."
  type        = list(string)

  default = [
    "main"
  ]
}

variable "gar_repo_name" {
  description = "Custom name to use for GAR repo."
  default     = ""
  type        = string
}

variable "random_suffix" {
  description = "Appends a 4 character random suffix to project ID and GCS bucket name."
  type        = bool
  default     = true
}


variable "cloud_build_config" {
  description = "The map of values that will be configured with a pull trigger."
  type = map(object({
      gcp_folder_suffix    = string
      workstream_path      = string
      included_files       = list(string)
      ignored_files        = list(string)
      pull_trigger_enabled = bool
      pull_gcbrun_enabled  = bool
      push_trigger_enabled = bool
  }))
}


variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = ""
}

variable "environment" {
  type        = string
  description = "P = Prod, N = NonProd, S = SandBox, etc."
}

variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
}
