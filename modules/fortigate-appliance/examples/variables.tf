/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "billing_account" {
  description = "Billing account"
}

variable "region" {
  default = "northamerica-northeast1"
}
variable "image_location" {
  description = "Project where source image is located"
  default     = "fortigcp-project-001"
}

variable "image" {
  description = "Name of Image to use"
  default     = "fortinet-fgtondemand-700-20210407-001-w-license"
}

variable "zone_1" {
  description = "Zone to place the first Fortigate appliance in"
  default     = "northamerica-northeast1-a"
}

variable "zone_2" {
  description = "Zone to place the second Fortigate appliance in"
  default     = "northamerica-northeast1-b"
}

variable "parent" {
  description = "Parent org or folder"
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

variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."
  default     = "Gc"
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
  default     = "utforti"
}

variable "location" {
  type        = string
  description = "location for naming and resource placement"
  default     = "northamerica-northeast1"
}
