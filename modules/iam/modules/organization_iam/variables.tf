/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "roles" {
  type        = list(any)
  description = "List of roles to assign to the organization"
}

variable "organization" {
  type        = string
  description = "Location to place SA in"
}

variable "member" {
  type        = string
  description = "Member to add roles to in the form of user:/group:/domain:account@email"
}