/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Module specific arguments
variable "user_defined_string" {
  type        = string
  description = "User defined string."
  default     = "example"
}

variable "additional_user_defined_string" {
  type        = string
  description = "Additional User defined string."
  default     = "function"
}