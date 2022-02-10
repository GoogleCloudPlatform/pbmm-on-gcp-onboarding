/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Module specific arguments
variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."
  default     = "tst001"
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
  default     = "guardrails"
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."
  default     = "abcd"
}
