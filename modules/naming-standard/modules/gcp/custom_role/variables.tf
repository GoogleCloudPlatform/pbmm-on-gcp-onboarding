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
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,61}[a-zA-Z0-9]$", var.user_defined_string))
    error_message = "The name must be 1-63 characters long and comply with RFC1035."
  }
}


# Module specific local variables
locals {
  type = {
    "code"   = "role"
    "parent" = "general"
  }

  device_type = "ROL"

  name_sections = {
    "user_defined_string" = var.user_defined_string,
  }
}