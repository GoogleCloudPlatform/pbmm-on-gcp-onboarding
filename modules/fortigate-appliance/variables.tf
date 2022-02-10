/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "image_location" {
  description = "Project where source image is located"
  default     = "fortigcp-project-001"

}

variable "image" {
  description = "Name of Image to use"
  default     = "fortinet-fgtondemand-646-20210531-001-w-license"
}

variable "network_tags" {
  description = "Network tags to add to instance"
  type        = list(any)
  default     = []
}

variable "project" {
  description = "Project to place the Fortigates in"
}

variable "zone_1" {
  description = "Zone to place the first Fortigate appliance in"
  default     = "northamerica-northeast1-a"
}

variable "zone_2" {
  description = "Zone to place the second Fortigate appliance in"
  default     = "northamerica-northeast1-b"
}

variable "compute_resource_policy" {
  description = "Policy to attach to the disks in the appliances"
  default     = ""
}

variable "compute_resource_policy_non_bootdisk" {
  description = "Policy to attach to the disks in the appliances"
  default     = ""
}


variable "machine_type" {
  description = "Instance size"
  type        = string
  default     = "n2-standard-2"
}

variable "network_ports" {
  description = "Configuration for ports on the fortigate devices, valid functions are currently public, ha, management and internal"
  type = map(object({
    port_name  = string
    project    = string
    subnetwork = string
  }))
}


variable "public_port" {
  description = "The map key of network_ports that is to be used for the public network"
  default     = "port1"
}

variable "ha_port" {
  description = "The map key of network_ports that is to be used for HA"
  default     = "port2"
}

// The `mgmt_port` variable is not currently being used
variable "mgmt_port" {
  description = "The map key of network_ports that is to be used for device management"
  default     = "port2"
}

variable "internal_port" {
  description = "The map key of network_ports that is to be used for internal network"
  default     = "port3"
}

variable "mirror_port" {
  description = "The map key of network_ports that is to be used for mirror network"
  default     = "port4"
}

variable "sleep_seconds" {
  description = "number of seconds to sleep before attempting to get the API key"
  default     = 100
}

variable "region" {
  description = "Region to place firwalls"
  default     = "northamerica-northeast1"
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

variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."
}

variable "user_defined_string" {
  type        = string
  description = "User defined string."
}

variable "location" {
  description = "Location for naming"
  default     = "northamerica-northeast1"
  type        = string
}