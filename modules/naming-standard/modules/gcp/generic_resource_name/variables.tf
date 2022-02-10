/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Module specific arguments
variable "resource_type" {
  type        = string
  description = "The resource type code, appended to the resource's name."

  validation {
    condition     = can(regex("^[\\w]+$", var.resource_type))
    error_message = "Special characters and spaces are not allowed."
  }
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."

  validation {
    condition     = can(regex("^[\\w-]+$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed (except hyphens)."
  }
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string. The SSC SACM end-state naming convention for CMDB and DNS compliance."
}

# Module specific local variables
locals {
  type = {
    "code"   = "generic"
    "parent" = "general"
  }

  device_type = var.device_type

  name_sections = {
    "type" = var.resource_type

    "user_defined_string" = var.user_defined_string,
  }
}