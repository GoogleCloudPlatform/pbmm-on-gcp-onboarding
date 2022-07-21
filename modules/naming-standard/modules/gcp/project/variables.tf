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
variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."

  validation {
    condition     = can(regex("^[\\w\\s]+$", var.owner))
    error_message = "Special characters are not allowed."
  }
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."

  validation {
    condition     = can(regex("^[\\w\\s]+$", var.user_defined_string))
    error_message = "Special characters are not allowed."
  }
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."

  default = ""

  validation {
    condition     = can(regex("^[\\w\\s]*$", var.additional_user_defined_string))
    error_message = "Special characters are not allowed."
  }
}

# Module specific local variables
locals {
  type = {
    "code" = "prj"
  }

  device_type = ""

  name_sections = {
    "owner"                          = var.owner,
    "user_defined_string"            = var.user_defined_string,
    "additional_user_defined_string" = var.additional_user_defined_string,
  }
}