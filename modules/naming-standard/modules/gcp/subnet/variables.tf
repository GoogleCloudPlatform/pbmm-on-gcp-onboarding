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
  description = "User defined string for the vpc."

  validation {
    condition     = can(regex("^[a-z](?:[-a-z0-9]{0,61}[a-z0-9])$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}

variable "additional_user_defined_string" {
  type        = string
  description = "User defined string for the subnet."

  validation {
    condition     = length(var.additional_user_defined_string) == 0 || can(regex("^[a-z](?:[-a-z0-9]{0,61}[a-z0-9])$", var.additional_user_defined_string))
    error_message = "Special characters and spaces are not allowed."
  }
}


# Module specific local variables
locals {
  type = {
    "code"   = "snet"
    "parent" = "vpc"
  }

  device_type = "CNR"

  name_sections = {
    "user_defined_string"            = var.user_defined_string,
    "additional_user_defined_string" = var.additional_user_defined_string,

    "set_case" = "lower",
  }
}