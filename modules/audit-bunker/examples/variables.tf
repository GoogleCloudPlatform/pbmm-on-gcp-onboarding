/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "region" {
  type        = string
  default     = "northamerica-northeast1"
  description = "region to deploy bucket"
}

variable "org_id" {
  type = string
}

variable "parent" {
  type = string
}

variable "billing_account" {
  type = string
}

variable "bucket_viewer" {
  type = string
}

variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = "Ga"
}

variable "environment" {
  type        = string
  description = "P = Prod, N = NonProd, S = SandBox, etc."
  default     = "P"
}

variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
  default     = "Lz"
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
  default     = ""
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."
  default     = ""
}