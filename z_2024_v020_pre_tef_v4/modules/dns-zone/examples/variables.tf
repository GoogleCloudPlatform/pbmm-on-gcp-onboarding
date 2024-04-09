/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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