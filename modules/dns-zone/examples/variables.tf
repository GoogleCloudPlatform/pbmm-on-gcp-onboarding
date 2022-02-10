/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "parent" {
  description = "folder/#### or organizations/### to place the project into"
  type        = string
}

variable "billing_account" {
  description = "billing account ID"
  type        = string
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

variable "network_self_links" {
  description = "Self link of the network that will be allowed to query the zone."
  default     = []
}

variable "private_zone_name" {
  description = "Private DNS zone name."
  default     = "private-local"
}

variable "private_zone_domain" {
  description = "Private Zone domain."
  default     = "private.local."
}

variable "public_zone_name" {
  description = "DNS zone name."
  default     = "gov-public-org"
}

variable "public_zone_domain" {
  description = "Zone domain."
  default     = "public.gov.ab.org."
}

variable "forwarding_zone_name" {
  description = "Forwarding DNS zone name."
  default     = "dns-local"
}

variable "forwarding_zone_domain" {
  description = "Forwarding Zone domain."
  default     = "dns.local."
}

variable "labels" {
  type        = map(any)
  description = "Labels for the ManagedZone"
  default = {
    owner   = "foo"
    version = "bar"
  }
}