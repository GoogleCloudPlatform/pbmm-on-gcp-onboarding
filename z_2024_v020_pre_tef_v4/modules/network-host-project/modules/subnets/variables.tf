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
  #experiments = [module_variable_optional_attrs]
}

variable "project_id" {
  description = "The ID of the project where subnets will be created"
}

variable "network_name" {
  description = "The name of the network where subnets will be created"
}

variable "subnet_name" {
  type = string
}

variable "description" {
  type = string
}

variable "subnet_private_access" {
  type = bool
}

variable "subnet_region" {
  type = string
}

variable "subnet_ip" {
  type = string
}

variable "secondary_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
}

variable "log_config" {
  type = object({
    aggregation_interval = optional(string)
    flow_sampling        = optional(number)
    metadata             = optional(string)
  })
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

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."
  default     = ""
}