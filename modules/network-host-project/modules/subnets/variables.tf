/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
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