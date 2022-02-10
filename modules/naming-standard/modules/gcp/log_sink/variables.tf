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
    condition     = can(regex("^[0-9A-Za-z-]+$", var.user_defined_string))
    error_message = "Must be alphanumeric and hyphens."
  }
}

# Module specific local variables
locals {
  type = {
    "code"   = "sink"
    "parent" = "general"
  }

  device_type = "CLD"

  name_sections = {
    "user_defined_string" = var.user_defined_string,
  }
}
