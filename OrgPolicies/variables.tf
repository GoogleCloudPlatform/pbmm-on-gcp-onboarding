variable "organization_id" {
  description = "The organization id for putting the policy"
  type        = string
}

variable "domains_to_allow" {
  description = "The list of domains to allow users from"
  type        = list(string)
}

