/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}
variable "org_policies" {
  description = "Optional additional policies"
  type = object(
    {
      directory_customer_id   = optional(list(string))
      policy_boolean          = optional(object({}))
      policy_list             = optional(object({}))
      setDefaultPolicy        = bool
      vmAllowedWithExternalIp = list(string)
      vmAllowedWithIpForward  = list(string)
    }
  )
}

variable "folders" {
  description = "folder/#### or organizations/### to place the project into"
  type = object(
    {
      parent       = string
      names        = list(string)
      subfolders_1 = map(string)
      subfolders_2 = map(string)
    }
  )
}

variable "audit" {
  description = "Values for the audit stream bucket configuration"
  type = object({
    user_defined_string            = string
    additional_user_defined_string = string
    billing_account                = string
    audit_streams = map(object({
      bucket_name          = string
      is_locked            = bool
      bucket_force_destroy = bool
      bucket_storage_class = string
      labels               = map(string)
      sink_name            = string #must be unique across organization
      description          = string
      filter               = string
      retention_period     = number
      bucket_viewer        = string
    }))
    audit_labels = optional(object({}))
  })
}

variable "access_context_manager" {
  description = "The object used for the access level policies."
  type = object(
    {
      policy_name         = string
      policy_id           = string
      access_level        = map(object({}))
      user_defined_string = string
    }
  )
}

variable "audit_project_iam" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object(
    {
      member  = string
      roles   = list(string)
      project = optional(string)
    }
  ))
  default = []
}

variable "folder_iam" {
  description = "List of accounts to grant roles to on a specified folder/########"
  type = list(object({
    member = string
    roles  = list(string)
    folder = optional(string)
    audit_folder_name = string
  }))
  default = []
}
variable "organization_iam" {
  description = "List of accounts to grant roles to with to the organizations/#######"
  type = list(object({
    member       = string
    roles        = list(string)
    organization = optional(string)
  }))
  default = []
}

variable "custom_roles" {
  description = "Map of roles to create"
  type = map(
    object({
      title       = string
      description = string
      role_id     = string
      permissions = list(string)
    })
  )
}

variable "service_accounts" {
  description = "List of service accounts to create and roles to assign to them"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
    project      = optional(string)
  }))
  default = []
}

variable "guardrails" {
  type = object({
    billing_account     = string
    org_id_scan_list    = list(string)
    org_client          = bool
    user_defined_string = string
  })
  description = "GCP guard rails are created using rego based policies in this project"
}