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



# GC Governance Fields - required arguments

variable "department_code" {
  type        = string
  description = "Two character department code. Format: Uppercase lowercase e.g. Sc."

  validation {
    condition     = can(regex("^[A-Z][a-z]$", var.department_code))
    error_message = "Department code is a two charater upper case lower case code."
  }
}

variable "environment" {
  type        = string
  description = "Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox"

  validation {
    condition = contains([
      "P",
      "D",
      "Q",
      "S",
      ],
    var.environment)
    error_message = "The environment value must be either: P, D, Q, S."
  }
}

variable "location" {
  type        = string
  description = "CSP and Region. Valid values: northamerica-northeast1. Code will be used for naming"

  validation {
    condition = contains([
      "northamerica-northeast1",
      ],
    var.location)
    error_message = "Valid location values: northamerica-northeast1."
  }
}
