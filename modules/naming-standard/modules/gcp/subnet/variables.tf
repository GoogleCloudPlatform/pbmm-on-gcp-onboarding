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
  description = "User defined string for the vpc."

  validation {
    condition     = can(regex("^[a-z](?:[-a-z0-9]{0,61}[a-z0-9])$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}

variable "additional_user_defined_string" {
  type        = string
  description = "User defined string for the subnet."

  validation {
    condition     = length(var.additional_user_defined_string) == 0 || can(regex("^[a-z](?:[-a-z0-9]{0,61}[a-z0-9])$", var.additional_user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}


# Module specific local variables
locals {
  type = {
    "code"   = "snet"
    "parent" = "vpc"
  }

  device_type = "CNR"

  name_sections = {
    "user_defined_string"            = var.user_defined_string,
    "additional_user_defined_string" = var.additional_user_defined_string,

    "set_case" = "lower",
  }
}