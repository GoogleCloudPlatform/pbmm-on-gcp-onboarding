variable "vpc_name" {
  type        = string
  description = "Name of the VPC to be peered with FortiGate hub."
}

variable "vpc_project" {
  type        = string
  description = "Name of the project hosting the spoke VPC to be peered with FortiGate hub."
}

variable "day0" {
  description = "Common output from day0 base FortiGate deployment"
}

variable "spoke_self_link" {
  type = string
  default = null
}

variable "spoke_ip_cidr_ranges" {
  type = set(string)
  default = []
}
