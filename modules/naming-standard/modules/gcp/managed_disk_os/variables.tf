/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Module specific arguments
variable "parent_resource" {
  type        = string
  description = "VM full name. Create parent resource name first and use output `result`."

  validation {
    condition     = can(regex("^[A-Z][a-z][A-Z][a-z][A-Z]{3}[\\w\\-]+\\d$", var.parent_resource))
    error_message = "Must be the full name of virtual machine."
  }
}

variable "number_suffix" {
  type        = string
  description = "Number suffix for the resource name."

  validation {
    condition     = can(regex("^[\\d]+$", var.number_suffix))
    error_message = "Only numbers are allowed."
  }

  default = "1"
}

# Module specific local variables
locals {
  type = {
    "code"   = "osdisk"
    "parent" = "compute_vm"
  }

  device_type = ""

  name_sections = {
    "parent_resource" = var.parent_resource,
    "number_suffix"   = var.number_suffix,
  }
}