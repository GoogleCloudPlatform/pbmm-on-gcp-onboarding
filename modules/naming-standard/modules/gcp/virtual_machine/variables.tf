/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Module specific arguments
variable "user_defined_string" {
  type        = string
  description = "User defined string."

  validation {
    condition     = can(regex("^[\\w]+$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string."

}

variable "number_suffix" {
  type        = string
  description = "Number suffix for the resource name."

  validation {
    condition     = can(regex("^\\d{2,}$", var.number_suffix))
    error_message = "Only numbers are allowed. Min two digits."
  }

  default = "01"
}

# Module specific local variables
locals {
  type = {
    "code"   = "vm"
    "parent" = "compute_vm"
  }

  device_type = var.device_type

  name_sections = {
    "user_defined_string" = var.user_defined_string,
    "number_suffix"       = var.number_suffix,
  }
}