/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

variable "project_id" {
  description = "The ID of the project where the routes will be created"
}

variable "network_name" {
  description = "The name of the network to attach to the cloud VPN"
}

variable "router_name" {
  type = string
}

variable "ha_vpn_name" {
  type = string
}

variable "ext_vpn_name" {
  type = string
}

variable "vpn_tunnel_name" {
  type = string
}

variable "peer_info" {
    type =  list(object({
        peer_asn        = string
        peer_ip_address = string
    }))
}

variable "peer_external_gateway" {
  type = object({
    redundancy_type = string
    interfaces      = list(object({
        id              = string
        router_ip_range = string
        ip_address      = string
    }))
  })
}

variable "tunnels" {
  description = "VPN tunnel configurations."
  type = object({
    ike_version                     = number
    vpn_gateway_interface           = number
  })
}

variable "region" {
  type = string
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
