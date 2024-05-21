variable "env" {
  description = "environment name"
  type        = string
}

variable "config_file" {
  description = "config file"
  type        = string
}
variable "remote_state_bucket" {
  description = "Backend bucket to load Terraform Remote State Data from previous steps."
  type        = string
}

