/**
 * Copyright 2023 Google LLC
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

variable "image_project" {
  description = "Project where source image is located"
  default     = "fortigcp-project-001"
}

variable "image_location" {
  description = "Regions where source image is stored in the image project"
  default     = "global"
}

# FortiGate Image name
# 7.4.1 x86 payg is projects/fortigcp-project-001/global/images/fortinet-fgtondemand-741-20230905-001-w-license
# 7.4.1 x86 byol is projects/fortigcp-project-001/global/images/fortinet-fgt-741-20230905-001-w-license
# 7.4.1 arm payg is projects/fortigcp-project-001/global/images/fortinet-fgtondemand-arm64-741-20230905-001-w-license
# 7.4.1 arm byol is projects/fortigcp-project-001/global/images/fortinet-fgt-arm64-741-20230905-001-w-license
variable "image_name" {
  description = "Name of Image to use"
  default     = "fortinet-fgtondemand-741-20230905-001-w-license"
}

variable "license_type" {
  description = "Order(License) type: PAYG = Pay As You Go, BYOL = Bring You Own License"
  default     = "PAYG"
}

variable "nictype" {
  type    = string
  default = "GVNIC"
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
  description = "Zone index in the given region to place the first Fortigate appliance in"
  default     = "a"
}

variable "zone_2" {
  description = "Zone index in the given region to place the second Fortigate appliance in"
  default     = "b"
}

# variable "compute_resource_policy" {
#   description = "Policy to attach to the disks in the appliances"
#   default     = ""
# }

# variable "compute_resource_policy_non_bootdisk" {
#   description = "Policy to attach to the disks in the appliances"
#   default     = ""
# }

variable "machine_type" {
  description = "Instance size"
  type        = string
  default     = "n2-standard-4"
}

variable "network_ports" {
  description = "Configuration for ports on the fortigate devices, valid functions are currently public(untrusted), ha, management and internal(trusted)"
  type = map(object({
    port_name  = string
    project    = string
    subnetwork = string
  }))
}

variable "public_port" {
  description = "The map key of network_ports that is to be used for the untrusted public network"
  default     = "port1"
}

variable "internal_port" {
  description = "The map key of network_ports that is to be used for trusted internal network"
  default     = "port2"
}

variable "ha_port" {
  description = "The map key of network_ports that is to be used for HA"
  default     = "port3"
}

variable "mgmt_port" {
  description = "The map key of network_ports that is to be used for device management"
  default     = "port4"
}

variable "sleep_seconds" {
  description = "number of seconds to sleep before attempting to get the API key"
  default     = 100
}

variable "lb_probe_port" {
  description = "probe service port used by loadbalancing health check"
  default     = "8008"
}

variable admin_acl {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs allowed to connect to FortiGate management interfaces. Defaults to 0.0.0.0/0"
}

variable workload_ip_cidr_range {
  type        = string
  default     = "10.0.0.0/8"
  description = "Workload CIDR allowed to routed from public network via FortiGate firewall. Defaults to 10.0.0.0/8"
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
