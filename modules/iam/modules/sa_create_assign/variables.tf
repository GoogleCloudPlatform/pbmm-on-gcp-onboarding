/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "account_id" {
  type        = string
  description = "ID for account email address, will be combined in output from naming module"
}
variable "display_name" {
  type        = string
  description = "Display name for service account"

}

variable "roles" {
  type        = list(string)
  description = "List of roles to assign to the service account"
}

variable "project" {
  type        = string
  description = "Location to place SA in"
}