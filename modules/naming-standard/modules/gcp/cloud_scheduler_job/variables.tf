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
    condition     = can(regex("^[[:alnum:]]+$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}

# Module specific local variables
locals {
  type = {
    "code"   = "csj"
    "parent" = "general"
  }

  device_type = "CPS"

  name_sections = {
    "user_defined_string" = var.user_defined_string,
  }
}
