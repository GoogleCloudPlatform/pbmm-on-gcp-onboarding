/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "project" {
  type        = string
  description = "Project to change permissions in"
}

variable "roles" {
  type        = list(any)
  description = "List of roles to assign to email"
}

variable "member" {
  type        = string
  description = "GCP account to apply roles to, must be in the form of (user|group|serviceAccount|domain):email@domain.com "
}