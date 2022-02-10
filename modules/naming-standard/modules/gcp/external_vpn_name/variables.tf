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
    condition     = can(regex("^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$", var.user_defined_string))
    error_message = "The name must be 1-63 characters long, and comply with RFC1035 the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  }
}

# Module specific local variables
locals {
  type = {
    "code"   = "extvpn"
    "parent" = "vpc"
  }

  device_type = "CNR"

  name_sections = {
    "user_defined_string" = var.user_defined_string,
    "set_case"            = "lower",
  }
}