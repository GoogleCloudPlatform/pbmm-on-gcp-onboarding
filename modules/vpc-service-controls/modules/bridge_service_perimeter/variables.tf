/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "policy" {
  description = "Name of the parent policy"
  type        = string
}

variable "description" {
  description = "Description of the bridge perimeter"
  type        = string
  default     = ""
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
}

variable "resources_by_numbers" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "resources_dry_run" {
  description = "(Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "resources_dry_run_by_numbers" {
  description = "(Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "dry_run" {
  default     = false
  description = "enable the dry run parameters"
  type        = bool
}

variable "live_run" {
  default     = false
  description = "enable the dry run parameters"
  type        = bool
}
