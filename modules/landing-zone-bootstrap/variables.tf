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




terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

variable labels {
  type = object({
      creator                = optional(string),
      date_created           = optional(string),
      date_modified          = optional(string),
      title                  = optional(string),
      department             = optional(string),
      imt_sector             = optional(string),
      environment            = optional(string),
      service_id             = optional(string),
      application_name       = optional(string),
      business_contact       = optional(string),
      technical_contact      = optional(string),
      general_ledger_account = optional(string),
      cost_center            = optional(string),
      internal_order         = optional(string),
      sos_id                 = optional(string),
      stra_id                = optional(string),
      security_classification= optional(string),
      criticality            = optional(string),
      hours_of_operation     = optional(string),
      project_code           = optional(string)
  })
}

variable "parent" {
  description = "folder/#### or organizations/### to place the project into"
  type        = string
}

variable "billing_account" {
  description = "billing account ID"
  type        = string
}

variable "default_region" {
  type    = string
  default = "northamerica-northeast1"
}

variable "org_id" {
  description = "ID alone in the for of ##### to create the deploy account"
  type        = string
}

variable "terraform_deployment_account" {
  description = "Service Account name"
  type        = string
}

variable "sa_org_iam_permissions" {
  description = "List of permissions granted to Terraform service account across the GCP organization."
  type        = list(string)
  default     = []
}

variable "bootstrap_email" {
  description = "Email of user:me@domain.com or group:us@domain.com to apply permissions to upload the state to the bucket once project as been created"
  type        = string
}

variable "services" {
  type        = list(string)
  description = "List of services to enable on the bootstrap project required for using their APIs"
}

variable "tfstate_buckets" {
  type = map(
    object({
      name          = string,
      labels        = optional(map(string)),
      force_destroy = optional(bool),
      storage_class = optional(string),
    })
  )
  description = "Map of buckets to store Terraform state files"
}

variable "set_billing_iam" {
  type        = bool
  default     = true
  description = "Disable for unit test as the SA is a Billing User. Requires Billing Administrator"
}


variable "cloud_source_repo_name" {
  type        = string
  description = "Name of the Cloud Source Repository referenced by Cloud Build"
}


# naming
variable "department_code" {
  type        = string
  description = "Code for department, part of naming module"
}

variable "environment" {
  type        = string
  description = "S-Sandbox P-Production Q-Quality D-development"
}

variable "location" {
  type        = string
  description = "location for naming and resource placement"
  default     = "northamerica-northeast1"
}

variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."
  default     = ""
}
