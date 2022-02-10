/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  type        = string
}

variable "policy_name" {
  description = "The policy's name, only used when creating a new policy"
  type        = string
  default     = "orgname-policy"
}

variable "policy_id" {
  type        = string
  description = "Policy ID is only used when a policy already exists"
  default     = null
}

variable "access_level" {
  description = "map used to configure an access level"
  type = map(
    object({
      name                             = optional(string)
      combining_function               = optional(string)
      description                      = optional(string)
      ip_subnetworks                   = optional(list(string))
      required_access_levels           = optional(list(string))
      members                          = optional(list(string))
      regions                          = optional(list(string))
      negate                           = optional(bool)
      require_screen_lock              = optional(bool)
      require_corp_owned               = optional(bool)
      allowed_encryption_statuses      = optional(list(string))
      allowed_device_management_levels = optional(list(string))
      minimum_version                  = optional(string)
      os_type                          = optional(string)
    })
  )
  default = {}
}

variable "regular_service_perimeter" {
  description = "map used to configure a regular service perimeter"
  type = map(object({
    description                  = optional(string)
    perimeter_name               = string
    restricted_services          = optional(list(string))
    resources                    = optional(list(string))
    resources_by_numbers         = optional(list(string))
    access_levels                = optional(list(string))
    restricted_services_dry_run  = optional(list(string))
    resources_dry_run            = optional(list(string))
    resources_dry_run_by_numbers = optional(list(string))
    access_levels_dry_run        = optional(list(string))
    vpc_accessible_services = optional(object({
      enable_restriction = bool,
      allowed_services   = list(string),
    }))
    dry_run  = optional(bool)
    live_run = optional(bool)
    })
  )
  default = {}
}

variable "bridge_service_perimeter" {
  description = "map used to configure a bridge service perimeter"
  type = map(object({
    description          = optional(string)
    perimeter_name       = string
    resources            = optional(list(string))
    resources_by_numbers = optional(list(string))
    })
  )
  default = {}
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

variable "user_defined_string" {
  type        = string
  description = "User defined string."
}