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
variable "user_defined_string" {
  type        = string
  description = "User defined string."

  validation {
    condition     = can(regex("^[\\w]+$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string."

}

variable "number_suffix" {
  type        = string
  description = "Number suffix for the resource name."

  validation {
    condition     = can(regex("^\\d{2,}$", var.number_suffix))
    error_message = "Only numbers are allowed. Min two digits."
  }

  default = "01"
}

# Module specific local variables
locals {
  type = {
    "code"   = "vm"
    "parent" = "compute_vm"
  }

  device_type = var.device_type

  name_sections = {
    "user_defined_string" = var.user_defined_string,
    "number_suffix"       = var.number_suffix,
  }
}