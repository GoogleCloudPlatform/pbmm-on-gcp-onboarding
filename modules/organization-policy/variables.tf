/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "organization_id" {
  description = "ID of GCP organization"
  type        = string
}

variable "directory_customer_id" {
  description = "GCP organization directory customer id"
  type        = list(string)
}

variable "vms_allowed_with_external_ip" {
  description = "Allowed list of VMs full URI that can have external ID"
  type        = list(string)
  default     = []
}

variable "vms_allowed_with_ip_forward" {
  description = "Allowed list of VMs full URI that can have external ID"
  type        = list(string)
  default     = []
}

variable "policy_boolean" {
  description = "Map of boolean org policies and enforcement value, set value to null for policy restore."
  type        = map(bool)
  default     = {}
}

variable "policy_list" {
  description = "Map of list org policies, status is true for allow, false for deny, null for restore. Values can only be used for allow or deny."
  type = map(object({
    inherit_from_parent = bool
    suggested_value     = string
    status              = bool
    values              = list(string)
  }))
  default = {}
}

variable "set_default_policy" {
  description = "A flag if true, then enable default policy, else set no default policy"
  type        = bool
  default     = true
}
