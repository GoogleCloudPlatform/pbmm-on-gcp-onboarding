/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "org_id" {
  description = "The organization ID this will be deployed to"
  type        = string
}
variable "org_id_scan_list" {
  description = "A list of organization_id's to scan."
  type        = list(string)
  default     = []
}
variable "org_client" {
  description = "True if this is a client organization. False if this is the core organization."
  type        = bool
  default     = false
}
variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}
variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}
variable "parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format to create the guardrails in."
  type        = string
  default     = null
  validation {
    condition     = var.parent == null || can(regex("(organizations|folders)/[0-9]+", var.parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}
variable "region" {
  description = "The default region of all resources."
  type        = string
  default     = "northamerica-northeast1"
}
variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = ""
}
variable "environment" {
  type        = string
  description = "P = Prod, D = Development, Q = QA, S = SandBox, etc."
}
variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
}
variable "user_defined_string" {
  type        = string
  description = "Environment modifier to deploy multiple instances"
  default     = ""
}
variable "additional_user_defined_string" {
  type        = string
  description = "Environment modifier to deploy multiple instances"
  default     = ""
}
variable "terraform_deployment_account" {
  description = "Terraform service account"
  type        = string
}