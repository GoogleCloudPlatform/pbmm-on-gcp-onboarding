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
  description = "The naming convention is defined by the cloud network team or resource owner of the route.  \ne.g. The PBMM VDC uses the following syntax: `to<device>_<source>_<destination>.`"

  validation {
    condition     = can(regex("^[\\w\\-]+$", var.user_defined_string))
    error_message = "No special characters or spaces allows."
  }
}


# Module specific local variables
locals {
  type = {
    "code"   = "route"
    "parent" = "vpc"
  }

  device_type = ""

  name_sections = {
    "user_defined_string" = var.user_defined_string,
  }
}