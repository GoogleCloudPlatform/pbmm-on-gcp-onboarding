/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "project_id" {
  type        = string
  description = "ID of audit project to create"
}

variable "org_id" {
  type        = string
  description = "Organization to place sink in"
}

variable "region" {
  type = string
}

variable "sink_name" {
  type = string
}

variable "description" {
  type        = string
  description = "Description of sink"
}

variable "bucket_name" {
  type = string
}

variable "filter" {
  type = string
}

variable "is_locked" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "retention_period" {
  type = string
}

variable "bucket_viewer" {
  type = string
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Used for testing, allow to destroy contents with retention period not met"
}

variable "storage_class" {
  type        = string
  description = "storage class of bucket"
}

variable "environment" {
  type        = string
  description = "P = Prod, N = NonProd, S = SandBox, etc."
}

variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."
  default     = ""
}