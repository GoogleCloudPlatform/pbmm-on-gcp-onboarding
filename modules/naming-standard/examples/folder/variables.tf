/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."
}

variable "project" {
  type        = string
  description = "Short string selected by the resource owner (aka user_defined_string)."
}