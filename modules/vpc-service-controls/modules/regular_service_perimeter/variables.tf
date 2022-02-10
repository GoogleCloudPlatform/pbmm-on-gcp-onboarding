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
  description = "Description of the regular perimeter"
  type        = string
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
}

variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "resources_by_numbers" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "access_levels" {
  description = "A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty."
  type        = list(string)
  default     = []
}

variable "restricted_services_dry_run" {
  description = "(Dry-run) GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions.  If set, a dry-run policy will be set."
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

variable "access_levels_dry_run" {
  description = "(Dry-run) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "vpc_accessible_services" {
  description = "only if you want to add VPC accessible services when you create the perimeter. Comma-separated list of one or more services that you want to allow networks inside your perimeter to access. Access to any services that are not included in this list will be prevented."
  type = object({
    enable_restriction = bool,
    allowed_services   = list(string),
  })
  default = {
    enable_restriction = true,
    allowed_services   = ["RESTRICTED-SERVICES"]
  }
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
