/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "network" {
  description = "The name of the VPC network being created"
  default     = "unittest-network"
}

variable "parent" {
  description = "folder/#### or organizations/### to place the project into"
  type        = string
}

variable "billing_account" {
  description = "billing account ID"
  type        = string
}

variable "iap_members" {
  description = "list of members to add to iap rule"
  type        = list(string)
  default     = []
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

variable "location" {
  type        = string
  description = "location for naming purposes."
  default     = "northamerica-northeast1"
}