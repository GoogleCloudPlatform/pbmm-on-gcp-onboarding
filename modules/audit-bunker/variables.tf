/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/




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
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format."
  type        = string
  default     = null
  validation {
    condition     = var.parent == null || can(regex("(organizations|folders)/[0-9]+", var.parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

variable "audit_streams" {
  type        = map(any)
  description = "Map of buckets to store audit logs"
}

variable labels {
  type = object({
      creator                = optional(string),
      date_created           = optional(string),
      date_modified          = optional(string),
      title                  = optional(string),
      department             = optional(string),
      imt_sector             = optional(string),
      environment            = optional(string),
      service_id             = optional(string),
      application_name       = optional(string),
      business_contact       = optional(string),
      technical_contact      = optional(string),
      general_ledger_account = optional(string),
      cost_center            = optional(string),
      internal_order         = optional(string),
      sos_id                 = optional(string),
      stra_id                = optional(string),
      security_classification= optional(string),
      criticality            = optional(string),
      hours_of_operation     = optional(string),
      project_code           = optional(string)
  })
}

variable "bucket_name" {
  type        = string
  description = "Billing account bucket name"
  default     = ""
}

variable "is_locked" {
  type        = bool
  description = "Bucket lock variable"
  default     = false
}

variable "bucket_force_destroy" {
  type        = bool
  description = "Bucket force destroy"
  default     = false
}

variable "bucket_storage_class" {
  type        = string
  description = "Bucket storage class"
  default     = ""
}

variable "sink_name" {
  type        = string
  description = "Bucket sink Name"
  default     = ""
}

variable "description" {
  type        = string
  description = "Bucket description"
  default     = ""
}

variable "filter" {
  type        = string
  description = "Filter criteria for the logs"
  default     = ""
} 

variable "retention_period" {
  type        = string
  description = "Filter criteria for the logs"
  default     = ""
}

variable "org_id" {
  type        = string
  description = "ID of organization place sink in"
}


variable "region" {
  type        = string
  description = "Bucket Region"
}

variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = ""
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