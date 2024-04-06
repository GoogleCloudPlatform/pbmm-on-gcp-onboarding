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
    condition     = can(regex("^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$", var.user_defined_string))
    error_message = "The name must be 1-63 characters long, and comply with RFC1035 the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  }
}


# Module specific local variables
locals {
  type = {
    "code"   = "fwr"
    "parent" = "vpc"
  }

  device_type = "FWL"

  name_sections = {
    "user_defined_string" = var.user_defined_string,

    "set_case" = "lower",
  }
}