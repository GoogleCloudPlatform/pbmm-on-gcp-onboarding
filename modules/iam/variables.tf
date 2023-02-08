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


variable "sa_create_assign" {
  description = "List of service accounts to create and roles to assign to them"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
    project      = optional(string)
  }))
  default = []
}

variable "project_iam" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object({
    member  = string
    roles   = list(string)
    project = optional(string)
  }))
  default = []
}

variable "compute_network_users" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object({
    members    = list(string)
    subnetwork = string
    region     = string
    project    = optional(string)
  }))
  default = []
}

variable "folder_iam" {
  description = "List of accounts to grant roles to on a specified folder/########"
  type = list(object({
    member      = string
    roles       = list(string)
    folder      = optional(string)
    folder_name = string
  }))
  default = []
}

variable "organization_iam" {
  description = "List of accounts to grant roles to with to the organizations/#######"
  type = list(object({
    member       = string
    roles        = list(string)
    organization = optional(string)
  }))
  default = []
}

variable "project" {
  description = "Project to apply changes to"
  type        = string
  default     = null
}

variable "organization" {
  description = "Organization to apply changes to"
  type        = string
  default     = null
}

variable "custom_role_name_id_map" {
  description = "Custom role name and id map"
  type        = map(string)
  default     = {}
}
