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
