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

variable "auto_create_network" {
  description = "Whether to create the default network for the project"
  type        = bool
  default     = false
}

variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "project_create" {
  description = "Boolean to determine if a new project should be created"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Resource labels."
  type        = map(string)
  default     = {}
}

variable "oslogin" {
  description = "Enable OS Login."
  type        = bool
  default     = false
}

variable "oslogin_admins" {
  description = "List of IAM-style identities that will be granted roles necessary for OS Login administrators."
  type        = list(string)
  default     = []
}

variable "oslogin_users" {
  description = "List of IAM-style identities that will be granted roles necessary for OS Login users."
  type        = list(string)
  default     = []
}

variable "parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format."
  type        = string
  default     = null
  validation {
    condition     = var.parent == null || can(regex("(organizations|folders)/[0-9]+", var.parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

variable "policy_boolean" {
  description = "Map of boolean org policies and enforcement value, set value to null for policy restore."
  type        = map(bool)
  default     = {}
}

variable "policy_list" {
  description = "Map of list org policies, status is true for allow, false for deny, null for restore. Values can only be used for allow or deny."
  type = map(object({
    inherit_from_parent = bool
    suggested_value     = string
    status              = bool
    values              = list(string)
  }))
  default = {}
}

variable "services" {
  description = "Service APIs to enable."
  type        = list(string)
  default     = []
}

variable "service_config" {
  description = "Configure service API activation."
  type = object({
    disable_on_destroy         = bool
    disable_dependent_services = bool
  })
  default = {
    disable_on_destroy         = true
    disable_dependent_services = true
  }
}

variable "shared_vpc_host_config" {
  description = "Configures this project as a Shared VPC host project (mutually exclusive with shared_vpc_service_project)."
  type        = bool
  default     = false
}

variable "shared_vpc_service_config" {
  description = "Configures this project as a Shared VPC service project (mutually exclusive with shared_vpc_host_config)."
  type = object({
    attach       = bool
    host_project = string
  })
  default = {
    attach       = false
    host_project = ""
  }
}

variable "iap_tunnel_members_list" {
  description = "list of users to grant iap.tunnelResourceAccessor role"
  type        = list(string)
  default     = []
}

variable "kms_encrypterdecrypter_members_list" {
  description = "list of users to grant cryptoKeyEncrypterDecrypter role"
  type        = list(string)
  default     = []
}

variable "default_cmk_encrypterdecrypter_members_list" {
  type        = list(string)
  description = "list of members to grant cryptoKeyEncrypterDecrypter role to the default cmk."
  default     = []
}

variable "enable_default_global_cmk" {
  description = "If create the default global cmk or not"
  type        = bool
  default     = false
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

variable "default_logging_metrics_create" {
  description = "Boolean to determine if default logging metrics should be created"
  type        = bool
  default     = true
}

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
