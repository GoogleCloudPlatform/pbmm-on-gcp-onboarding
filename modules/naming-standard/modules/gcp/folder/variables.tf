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
    condition     = can(regex("^[\\w]*$", var.owner))
    error_message = "Spaces and special characters are not allowed."
  }

  default = ""
}

variable "project" {
  type        = string
  description = "Short string selected by the resource owner (aka user_defined_string)."

  validation {
    condition     = can(regex("^[\\w\\s]+$", var.project))
    error_message = "Special characters are not allowed."
  }
}

# Module specific local variables
locals {
  type = {
    "code" = "folder"
  }

  device_type = ""

  name_sections = {
    "owner"               = var.owner,
    "user_defined_string" = var.project,
  }
}