/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "project_id" {
  description = "Project id for the zone."
  type        = string
}
variable "domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "private_visibility_config_networks" {
  description = "List of VPC self links that can see this zone."
  default     = []
  type        = list(string)
}

variable "target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  default     = []
  type        = list(map(any))
}

variable "target_network" {
  description = "Peering network."
  default     = ""
}

variable "description" {
  description = "Description of Managed Zone"
  type        = string
}

variable "type" {
  description = "public, private, forwarding or peering."
  default     = "private"
  type        = string
}

variable "dnssec_config" {
  description = "Object containing : kind, non_existence, state. See https://cloud.google.com/dns/docs/reference/v1/managedZones for valid kind, non_existence and state values."
  type        = any
  default     = {}
}

variable "labels" {
  type        = map(any)
  description = "Key value pairs for labels for the Managed Zone."
  default     = {}
}

variable "default_key_specs_key" {
  description = "Key Signing Object : algorithm, key_length, key_type, kind. See https://cloud.google.com/dns/docs/reference/v1/managedZones for valid values for each field."
  type        = any
  default     = {}
}

variable "default_key_specs_zone" {
  description = "Zone Signing Object : algorithm, key_length, key_type, kind. See https://cloud.google.com/dns/docs/reference/v1/managedZones for valid values for each field."
  type        = any
  default     = {}
}

variable "force_destroy" {
  description = "Set this true to delete all records in the zone."
  default     = false
  type        = bool
}

variable "dns_policy_network" {
  description = "Network name used by DNS Server Policy."
  default     = null
  type        = string
}

variable "enable_inbound_forwarding" {
  description = "Set this to true to enable default Google DNS Server for inbound forwarding."
  default     = false
  type        = bool
}


variable "enable_logging" {
  description = "Set this to true to enable DNS logging."
  default     = false
  type        = bool
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraform dns structure."
  default     = []
}