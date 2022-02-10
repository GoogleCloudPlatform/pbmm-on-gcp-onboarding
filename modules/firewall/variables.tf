/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "network" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}

variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
}

variable "zone_list" {
  description = "List of all zone where all communicaiton within the zone itself is allow, traffic to other zones still requires other rules"
  type        = list(any)
  default = [
    "public-access-zone",
    "operations-zone",
    "restricted-zone",
    "management-restricted-zone"
  ]
}

variable "internal_ranges_enabled" {
  description = "Create rules for intra-VPC ranges."
  type        = bool
  default     = false
}

variable "internal_ranges" {
  description = "IP CIDR ranges for intra-VPC rules."
  type        = list(string)
  default     = []
}

variable "internal_target_tags" {
  description = "List of target tags for intra-VPC rules."
  type        = list(string)
  default     = []
}

variable "internal_allow" {
  description = "Allow rules for internal ranges."
  default = [
    {
      protocol = "icmp"
    },
  ]
}

variable "admin_ranges_enabled" {
  description = "Enable admin ranges-based rules."
  type        = bool
  default     = false
}

variable "admin_ranges" {
  description = "IP CIDR ranges that have complete access to all subnets."
  type        = list(string)
  default     = []
}

variable "custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
}

variable "enable_bastion_ports" {
  description = "enable IAP via ports 22 and 3389"
  type        = bool
  default     = true
}

variable "custom_iap_rules" {
  description = "Object of rules to add to the firewall for IAP access to custom ports"
  type = map(object({
    rule_name = string
    protocol  = string
    ports     = list(string)
    })
  )
  default = {}
}

variable "environment" {
  type        = string
  description = "P = Prod, N = NonProd, S = SandBox, etc."
}

variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
}

variable "location" {
  type        = string
  description = "location for naming purposes."
}