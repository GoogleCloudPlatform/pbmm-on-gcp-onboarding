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



terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  #experiments = [module_variable_optional_attrs]
}

variable "project_id" {
  description = "The ID of the project where the routes will be created"
}

variable "network_name" {
  description = "The name of the network to attach to this router"
}

variable "router_name" {
  type = string
}

variable "description" {
  type = string
}

variable "region" {
  type = string
}

variable "bgp" {
  type = object({
    asn               = number
    advertise_mode    = optional(string)
    advertised_groups = optional(list(string))
    advertised_ip_ranges = optional(list(object({
      range       = string
      description = optional(string)
    })))
  })
}

variable "vpn_config" {
  type = list(object({
    ha_vpn_name           = string
    ext_vpn_name          = optional(string)
    vpn_tunnel_name       = string
    peer_info             = list(object({
        peer_asn        = string
        peer_ip_address = string
    }))
    peer_external_gateway = object({
        redundancy_type = string
        interfaces      = list(object({
            id              = string
            router_ip_range = string
            ip_address      = string
        }))
    })
    tunnels = object({
        # bgp_session_range               = string
        ike_version                     = number
        vpn_gateway_interface           = number
        # peer_external_gateway_interface = number
    })
  }))
  default = []
}

#naming
variable "department_code" {
  type        = string
  description = "Code for department, part of naming module"
}

variable "environment" {
  type        = string
  description = "S-Sandbox P-Production Q-Quality D-development"
}

variable "location" {
  type        = string
  description = "location for naming and resource placement"
  default     = "northamerica-northeast1"
}
