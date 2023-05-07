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
  description = "User defined string. Name must have lowercase letters, can contain numbers and hyphens. Min 3 characters, max 52 characters."

  validation {
    condition     = can(regex("^[a-z][0-9a-z-]{3,51}$", var.user_defined_string))
    error_message = "Name must have lowercase letters, can contain numbers and hyphens. Min 3 characters, max 52 characters."
  }
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string."

}

# Module specific local variables
locals {
  type = {
    "code"   = "ig"
    "parent" = "compute_vm"
  }

  # Can use the Generic Cloud Entity device type "CLD"
  device_type = "CLD"

  name_sections = {
    "user_defined_string" = var.user_defined_string,
    "set_case"            = "lower",
  }
}