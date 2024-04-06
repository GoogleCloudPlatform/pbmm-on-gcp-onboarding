/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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