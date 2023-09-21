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

variable "org_id" {
  description = "The organization ID this will be deployed to"
  type        = string
}
variable "org_id_scan_list" {
  description = "A list of organization_id's to scan."
  type        = list(string)
  default     = []
}
variable "org_client" {
  description = "True if this is a client organization. False if this is the core organization."
  type        = bool
  default     = false
}
variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}
variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}
variable "bucket_log_bucket" {
  type        = string
  description = "Name of bucket access and storage log bucket"
}
variable "parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format to create the guardrails in."
  type        = string
  default     = null
  validation {
    condition     = var.parent == null || can(regex("(organizations|folders)/[0-9]+", var.parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}
variable "region" {
  description = "The default region of all resources."
  type        = string
  default     = "northamerica-northeast1"
}
variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = ""
}
variable "environment" {
  type        = string
  description = "P = Prod, D = Development, Q = QA, S = SandBox, etc."
}
variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
}
variable "user_defined_string" {
  type        = string
  description = "Environment modifier to deploy multiple instances"
  default     = ""
}
variable "additional_user_defined_string" {
  type        = string
  description = "Environment modifier to deploy multiple instances"
  default     = ""
}
variable "terraform_sa_project" {
  description = "GCP Project where the Terraform Service Account(s) exist"
  type        = string
}

variable "workerpool_project_id" {
  type        = string
  description = "The id of the project with CloudBuild private worker pool"
  default     = null
}

variable "workerpool_id" {
  type        = string
  description = "The id of CloudBuild private worker pool"
  default     = null
}
