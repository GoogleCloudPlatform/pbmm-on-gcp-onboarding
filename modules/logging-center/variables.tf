/**
 * Copyright 2023 Google LLC
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

# project-related
variable "parent" {
  description = "folder/#### or organizations/#### to place the project into"
  type        = string
}

variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}

variable "billing_account" {
  description = "billing account ID"
  type        = string
}

variable "projectlabels" {
  type = object({
    creator                 = optional(string),
    date_created            = optional(string),
    date_modified           = optional(string),
    title                   = optional(string),
    department              = optional(string),
    imt_sector              = optional(string),
    environment             = optional(string),
    service_id              = optional(string),
    application_name        = optional(string),
    business_contact        = optional(string),
    technical_contact       = optional(string),
    general_ledger_account  = optional(string),
    cost_center             = optional(string),
    internal_order          = optional(string),
    sos_id                  = optional(string),
    stra_id                 = optional(string),
    security_classification = optional(string),
    criticality             = optional(string),
    hours_of_operation      = optional(string),
    project_code            = optional(string)
  })
}

# IAM
variable "log_bucket_viewer_members_list" {
  description = "list of users to grant roles/logging.viewAccessor role"
  type        = list(string)
  default     = []
}

# Log-based metrics
variable "additional_user_defined_logging_metrics" {
  type = list(object({
    name   = string
    filter = string
    metric_descriptor = object({
      metric_kind = string
      value_type  = string
    })
  }))
  description = "Additional used-defined logging metrics"
  default     = []
}

# Log buckets
variable "simple_central_log_bucket" {
  type = object({
    name           = string
    description    = string
    location       = string
    retention_days = number
    source_organization_sink = optional(object({
      organization_id  = string
      include_children = optional(bool)
      inclusion_filter = optional(string)
      exclusion_filters = optional(list(object({
        name        = string
        description = optional(string)
        filter      = string
        disabled    = optional(bool)
      })))
      disabled = optional(bool)
    }))
    source_folder_sink = optional(object({
      folder           = string
      include_children = optional(bool)
      inclusion_filter = optional(string)
      exclusion_filters = optional(list(object({
        name        = string
        description = optional(string)
        filter      = string
        disabled    = optional(bool)
      })))
      disabled = optional(bool)
    }))
    source_billing_account_sinks = optional(object({
      billing_account  = string
      inclusion_filter = optional(string)
      exclusion_filters = optional(list(object({
        name        = string
        description = optional(string)
        filter      = string
        disabled    = optional(bool)
      })))
      disabled = optional(bool)
    }))
    exporting_project_sink = optional(object({
      destination_bucket          = string
      destination_bucket_location = string
      destination_project         = string
      retention_period            = number
      unique_writer_identity      = bool
      inclusion_filter            = optional(string)
      exclusion_filters = optional(list(object({
        name        = string
        description = optional(string)
        filter      = string
        disabled    = optional(bool)
      })))
      disabled = optional(bool)
    }))
  })
  description = "The central log bucket with source sink config"
}

variable "bucket_log_bucket" {
  type        = string
  description = "Name of bucket access and storage log bucket"
  default     = null
}

variable "project_services" {
  type        = list(string)
  description = "Service APIs to enable for the logging center project"
  default     = null
}
