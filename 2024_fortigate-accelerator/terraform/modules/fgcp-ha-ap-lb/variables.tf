terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
    }
  }
}

variable region {
  type        = string
  default     = "europe-west1"
  description = "Region to deploy all resources in. Must match var.zones if defined."
}

variable prefix {
  type        = string
  default     = "fgt"
  description = "This prefix will be added to all created resources"
}

variable zones {
  type        = list(string)
  default     = ["",""]
  description = "Names of zones to deploy FortiGate instances to matching the region variable. Defaults to first 2 zones in given region."
}

variable subnets {
  type        = list(string)
  description = "Names of four existing subnets to be connected to FortiGate VMs (external, internal, heartbeat, management)"
  validation {
    condition     = length(var.subnets) == 4
    error_message = "Please provide exactly 4 subnet names (external, internal, heartbeat, management)."
  }
}

variable machine_type {
  type        = string
  default     = "e2-standard-4"
  description = "GCE machine type to use for VMs. Minimum 4 vCPUs are needed for 4 NICs"
}

variable service_account {
  type        = string
  default     = ""
  description = "E-mail of service account to be assigned to FortiGate VMs. Defaults to Default Compute Engine Account"
}

variable admin_acl {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs allowed to connect to FortiGate management interfaces"
}

variable api_acl {
  type        = list(string)
  default     = []
  description = "List of CIDRs allowed to connect to FortiGate API (must not be 0.0.0.0/0)"
}

variable license_files {
  type        = list(string)
  default     = ["NONE","NONE"]
  description = "List of license (.lic) files to be applied for BYOL instances."
}

variable healthcheck_port {
  type        = number
  default     = 8008
  description = "Port used for LB health checks"
}
