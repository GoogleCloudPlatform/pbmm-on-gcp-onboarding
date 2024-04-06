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

# naming
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

variable "additional_user_defined_string" {
  type        = string
  description = "Additional user defined string."
  default     = ""
}

# networks
variable "network_name" {
  type = string
}
variable "description" {
  type    = string
  default = ""
}
variable "routing_mode" {
  type    = string
  default = "GLOBAL"
}
variable "shared_vpc_host" {
  type    = bool
  default = false
}
variable "auto_create_subnetworks" {
  type    = bool
  default = false
}
variable "delete_default_internet_gateway_routes" {
  type    = bool
  default = false
}
variable "peer_project" {
  type    = string
  default = ""
}
variable "peer_network" {
  type    = string
  default = ""
}
variable "mtu" {
  type    = number
  default = 1460
}
# subnets
variable "subnets" {
  type = list(object({
    subnet_name           = string
    description           = optional(string)
    subnet_private_access = optional(bool)
    subnet_region         = optional(string)
    subnet_ip             = string
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })))
    log_config = optional(object({
      aggregation_interval = optional(string)
      flow_sampling        = optional(number)
      metadata             = optional(string)
    }))
  }))
}
# routes
variable "routes" {
  type = list(object({
    route_name                        = string
    description                       = optional(string)
    destination_range                 = string
    next_hop_default_internet_gateway = optional(bool)
    next_hop_gateway                  = optional(string)
    next_hop_ip                       = optional(string)
    next_hop_instance                 = optional(string)
    next_hop_instance_zone            = optional(string)
    next_hop_vpn_tunnel               = optional(string)
    priority                          = optional(number)
    tags                              = optional(list(string))
  }))
  default = []
}
variable "routers" {
  type = list(object({
    router_name = string
    description = optional(string)
    region      = optional(string)
    bgp = optional(object({
      asn               = number
      advertise_mode    = optional(string)
      advertised_groups = optional(list(string))
      advertised_ip_ranges = optional(list(object({
        range       = string
        description = optional(string)
      })))
    }))
  }))
  default = []
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

#others
variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}
