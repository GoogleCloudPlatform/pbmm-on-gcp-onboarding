/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "project" {
  type        = string
  description = "name of project"
}

variable "domain" {
  type        = string
  description = "domain used in vm hostname"
  default     = "prd.gcp.gov.ab.ca"
}

variable "number_suffix" {
  type        = string
  description = "Number suffix for the resource name."

  validation {
    condition     = can(regex("^\\d{2,}$", var.number_suffix))
    error_message = "Only numbers are allowed. Min two digits."
  }

  default = "01"
}

variable "machine_type" {
  default     = "n1-standard-2"
  description = "VM size"
}

variable "boot_disk_type" {
  default     = "pd-standard"
  description = "Disk type, valid options are [pd-ssd,pd-standard]"
}

variable "vm_zone" {
  default     = "northamerica-northeast1-a"
  description = "GCE zone to deploy VM"
}

variable "network_tags" {
  default     = []
  description = "Network tags for firewall rules"
}

variable "metadata" {
  description = "custom_metadata to add to the instance"
  type        = map(string)
  default     = {}
}

variable "image_location" {
  description = "Instance source image project"
}

variable "image" {
  default     = "rhel-latest"
  description = "Image name"
}

variable "boot_disk_size" {
  default     = "20"
  description = "Size of boot/root disk"
}

variable "network_interfaces" {
  description = "Map of objects containing network interfaces. id sets the order of the attachement to the VM"
  type = list(object({
    id                 = string # sets the order of the attachement to the VM
    subnetwork         = string
    subnetwork_project = string
    network_ip         = optional(string)
    access_config = optional(list(object({
      nat_ip       = string
    })))
  }))
}

variable "can_ip_forward" {
  description = "Ability to act as a router on the network"
  default     = false
  type        = bool
}

variable "labels" {
  type        = map(string)
  description = "Labels to place on the VM"
  default     = {}
}

variable "service_account_scopes" {
  default     = []
  description = "GCE scopes which VM should be able to access and/or change"
}

variable "service_account_email_address" {
  description = "Service account to run the VM"
}

variable "disks" {
  description = "Disks map for extra disks"
  type = list(object({
    id   = string
    type = string
    size = number
  }))
  default = []
}

variable "compute_resource_policy" {
  description = "Disk snapshot policy, if left as none, no policy will be applied"
  default     = ""
}

variable "compute_resource_policy_non_bootdisk" {
  description = "Disk snapshot policy, if left as none, no policy will be applied"
  default     = ""
}

variable "metadata_startup_script" {
  type        = string
  default     = null
  description = "startup script for vm"
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

variable "user_defined_string" {
  type        = string
  description = "User defined string."
}

variable "device_type" {
  type        = string
  description = "Device type for naming purposes"
}