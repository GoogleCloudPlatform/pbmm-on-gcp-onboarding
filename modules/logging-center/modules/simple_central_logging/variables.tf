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

# Project
variable "project_id" {
  description = "project ID to use for creating core logging center."
  type        = string
}

variable "location" {
  type        = string
  description = "default project location for project resource placement"
  default     = "northamerica-northeast1"
}

# CMEK
variable "customer_managed_key_id" {
  description = "CMEK ID to use for encrypting logging buckets."
  type        = string
}

# IAM
variable "log_bucket_viewer_members_list" {
  description = "list of users to grant roles/logging.viewAccessor role"
  type        = list(string)
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
