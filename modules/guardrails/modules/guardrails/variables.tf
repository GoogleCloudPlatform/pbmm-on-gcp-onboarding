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
  description = "A list of organization id's to scan."
  type        = list(string)
}
variable "project_id" {
  description = "The project ID to deploy guardrails resources to."
  type        = string
}
variable "region" {
  description = "The default region of all resources."
  type        = string
  default     = "northamerica-northeast1"
}
variable "asset_inventory_job_schedule" {
  description = "The a string representing the CRON schedule of generating asset inventory.  Default is daily at 8AM EST"
  type        = string
  default     = "0 8 * * *"
}
variable "trigger_branch_name" {
  description = "The main branch name of all CSR repositories"
  type        = string
  default     = "main"
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
}
variable "additional_user_defined_string" {
  type        = string
  description = "Environment modifier to deploy multiple instances"
}
variable "terraform_sa_project" {
  description = "GCP Project where the Terraform Service Account(s) exist"
  type        = string
}
variable "customer_managed_key_id" {
  type        = string
  description = "Id of customer managed key"
  default     = ""
}

variable "bucket_log_bucket" {
  type        = string
  description = "Name of bucket access and storage log bucket"
}
