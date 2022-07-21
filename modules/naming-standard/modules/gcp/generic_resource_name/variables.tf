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
variable "resource_type" {
  type        = string
  description = "The resource type code, appended to the resource's name."

  validation {
    condition     = can(regex("^[\\w]+$", var.resource_type))
    error_message = "Special characters and spaces are not allowed."
  }
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."

  validation {
    condition     = can(regex("^[\\w-]+$", var.user_defined_string))
    error_message = "Special characters and spaces are not allowed (except hyphens)."
  }
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string. The SSC SACM end-state naming convention for CMDB and DNS compliance."
}

# Module specific local variables
locals {
  type = {
    "code"   = "generic"
    "parent" = "general"
  }

  device_type = var.device_type

  name_sections = {
    "type" = var.resource_type

    "user_defined_string" = var.user_defined_string,
  }
}