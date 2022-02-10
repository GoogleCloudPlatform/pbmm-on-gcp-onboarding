/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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
