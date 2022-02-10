/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "project_id" {
  description = "The ID of the project where the routes will be created"
}

variable "network_name" {
  description = "The name of the network where routes will be created"
}

variable "route_name" {
  type = string
}
variable "description" {
  type = string
}
variable "destination_range" {
  type = string
}
variable "next_hop_gateway" {
  type = string
}
variable "next_hop_ip" {
  type = string
}
variable "next_hop_instance" {
  type = string
}
variable "next_hop_instance_zone" {
  type = string
}
variable "next_hop_vpn_tunnel" {
  type = string
}
variable "priority" {
  type = number
}
variable "tags" {
  type = list(string)
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}
