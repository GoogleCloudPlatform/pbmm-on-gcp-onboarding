/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Module specific arguments
variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."

  validation {
    condition     = can(regex("^[\\w\\s]+$", var.owner))
    error_message = "Special characters are not allowed."
  }
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."

  validation {
    condition     = can(regex("^[\\w\\s]+$", var.user_defined_string))
    error_message = "Special characters are not allowed."
  }
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."

  default = ""

  validation {
    condition     = can(regex("^[\\w\\s]*$", var.additional_user_defined_string))
    error_message = "Special characters are not allowed."
  }
}

# Module specific local variables
locals {
  type = {
    "code" = "prj"
  }

  device_type = ""

  name_sections = {
    "owner"                          = var.owner,
    "user_defined_string"            = var.user_defined_string,
    "additional_user_defined_string" = var.additional_user_defined_string,
  }
}