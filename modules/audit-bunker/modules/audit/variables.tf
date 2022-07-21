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