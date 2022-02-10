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
  description = "User defined string. Name must have lowercase letters, can contain numbers and hyphens. Min 3 characters, max 52 characters."

  validation {
    condition     = can(regex("^[a-z][0-9a-z-]{3,51}$", var.user_defined_string))
    error_message = "Name must have lowercase letters, can contain numbers and hyphens. Min 3 characters, max 52 characters."
  }
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string."

}

# Module specific local variables
locals {
  type = {
    "code"   = "ig"
    "parent" = "compute_vm"
  }

  # Can use the Generic Cloud Entity device type "CLD"
  device_type = "CLD"

  name_sections = {
    "user_defined_string" = var.user_defined_string,
    "set_case"            = "lower",
  }
}