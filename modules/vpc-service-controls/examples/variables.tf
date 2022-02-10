/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
  default     = "unittest"
}

variable "policy_id" {
  type        = string
  description = "Policy ID is only used when a policy already exists"
  default     = ""
}

variable "members" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}

variable "regions" {
  description = "The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
  type        = list(string)
  default     = ["CA"]
}

variable "access_level_name" {
  description = "Access level name of the Access Policy."
  type        = string
  default     = "ac1"
}

variable "bridge_perimeter_name" {
  description = "Perimeter name of the Access Policy.."
  type        = string
  default     = "bp1"
}

variable "regular_perimeter_name" {
  description = "Perimeter name of the Access Policy.."
  type        = string
  default     = "rp1"
}

variable "dataset_id" {
  description = "Unique dataset ID/name that will be created."
  type        = string
  default     = "sample_dataset"
}

variable "parent" {
  description = "folder/#### or organizations/### to place the project into"
  type        = string
}

variable "billing_account" {
  description = "billing account ID"
  type        = string
}

# naming
variable "department_code" {
  type        = string
  description = "Code for department, part of naming module"
  default     = "Sc"
}

variable "environment" {
  type        = string
  description = "S-Sandbox P-Production Q-Quality D-development"
  default     = "D"
}

variable "location" {
  type        = string
  description = "location for naming and resource placement"
  default     = "northamerica-northeast1"
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
  default     = "unittest"
}