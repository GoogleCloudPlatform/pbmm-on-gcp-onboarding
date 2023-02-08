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



# GC Governance Fields - required arguments

variable "gc_prefix" {
  type        = string
  description = "GC governance prefix."
}

variable "name_sections" {
  type        = map(any)
  description = "Key Value pairs of naming sections for text replacement."
}

# Device suffix based on Microsoft best practice:
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging
variable "type" {
  type        = string
  description = "For supported types see ./config/resource_naming_patterns.yaml and ./config/resource_types.yaml for codes."

  validation {
    condition = contains([
      "generic",
      "folder",
      "prj",
      "cig",
      "vpc",
      "nat",
      "snet",
      "route",
      "router",
      "fwr",
      "stg",
      "sa",
      "sink",
      "cbt",
      "csj",
      "cf",
      "vsc",
      "ip",
      "eip",
      "bs",
      "rbs",
      "fr",
      "gfr",
      "hc",
      "role",
      "cntr",
      "vm",
      "ig",
      "vmr",
      "fwl",
      "osdisk",
      "datadisk",
      "cit",
      "havpn",
      "extvpn",
      "vpntun",
      ],
    var.type)
    error_message = "For supported types see ./config/resource_naming_patterns.yaml."
  }
}

variable "type_parent" {
  type        = string
  description = "For type parents see ./config/resource_naming_patterns.yaml and ./config/resource_types.yaml for codes."

  validation {
    condition = contains([
      "",
      "general",
      // Cloud Identity Group
      "cig",
      // network - vpc
      "vpc",
      // Compute Address - Internal Static IP
      "ip",
      // Compute Address - External Static IP
      "eip",
      // Backend Service
      "bs",
      // Region Backend Service
      "rbs",
      // Forwarding Rule
      "fr",
      // Global Forwarding Rule
      "gfr",
      // health check
      "hc",
      // storage
      "storage",
      "compute_vm",
      // Compute Instance Template
      "cit",
      ],
    var.type_parent)
    error_message = "For type parents see ./config/resource_naming_patterns.yaml."
  }

  default = ""
}

# Reference <project_root_path>/configs/device_types.yaml for description
variable "device_type" {
  type        = string
  description = "Three character string. The SSC SACM end-state naming convention for CMDB and DNS compliance."

  default = ""

  validation {
    # specific device type codes
    # or for server (SRV) device types, a specific three character code is required
    # starting with the letter 'S'
    condition = contains([
      "BST",
      "FWL",
      "ADC",
      "IDS",
      "IPS",
      "RTR",
      "XSW",
      "QFC",
      "VDI",
      "CLD",
      "CNR",
      "CSA",
      "CSV",
      "CCR",
      "CPS",
      "CLD",
      "CNR",
      "CSA",
      "CPS",
      "VSC",
      "ROL",
      "",
      # Extensible
    ], var.device_type) || can(regex("^S[WLAX][A-HVXJ]$", var.device_type))
    error_message = "Device type is a three character uppercase string which must be a device type code defined from the validation."
  }
}
