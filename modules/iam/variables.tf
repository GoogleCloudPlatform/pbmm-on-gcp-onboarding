/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "sa_create_assign" {
  description = "List of service accounts to create and roles to assign to them"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
    project      = optional(string)
  }))
  default = []
}

variable "project_iam" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object({
    member  = string
    roles   = list(string)
    project = optional(string)
  }))
  default = []
}

variable "compute_network_users" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object({
    members    = list(string)
    subnetwork = string
    region     = string
    project    = optional(string)
  }))
  default = []
}

variable "folder_iam" {
  description = "List of accounts to grant roles to on a specified folder/########"
  type = list(object({
    member = string
    roles  = list(string)
    folder = string
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

variable "project" {
  description = "Project to apply changes to"
  type        = string
  default     = null
}

variable "organization" {
  description = "Organization to apply changes to"
  type        = string
  default     = null
}