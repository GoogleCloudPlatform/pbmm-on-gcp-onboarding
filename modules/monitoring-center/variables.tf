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

variable "project" {
  description = "The project ID of the existing metrics scoping project"
  type        = string
  default     = null
}

# IAM
variable "monitoring_viewer_members_list" {
  description = "list of users to grant roles/monitoring.viewer role"
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

variable "monitored_projects" {
  type        = list(any)
  description = "List of projects to be monitored by the scoping project"
}

variable "monitoring_alert_policies" {
  type = list(object({
    display_name = string
    combiner     = string
    conditions = list(object({
      display_name = string
      condition_threshold = object({
        filter     = optional(string)
        duration   = string
        comparison = string
        aggregations = optional(object({
          alignment_period   = string
          per_series_aligner = string
        }))
        evaluation_missing_data = optional(string)
      })
    }))
    user_labels = optional(map(string))
  }))
  description = "List of used-defined monitoring alert policy"
  default     = []
}

variable "notification_emails" {
  type        = list(string)
  description = "List of emails used to send alert nitification"
  default     = []
}
