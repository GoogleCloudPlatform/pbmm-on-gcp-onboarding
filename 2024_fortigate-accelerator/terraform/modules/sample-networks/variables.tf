variable "prefix" {
  type = string
  description = "Prefix to be added to all created resources"
}

variable "region" {
  type = string
  description = "Region to deploy to"
  default = "europe-west1"
}

variable "networks" {
  type        = list(string)
  description = "List of sample networks names"
  default     = ["external", "internal", "hasync", "mgmt"]
}

variable "ip_cidr_2oct" {
  type = string
  description = "CIDR /16 range for created subnets"
  default = "172.20"
}
