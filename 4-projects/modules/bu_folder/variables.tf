
variable "env" {
    description = "environment"
    type = string
}

//variable "bu_config" {
//    description = "business unit config"
//    type = any
//
//}
variable "business_code" {
    description = "business_code"
    type = string

}

variable "business_unit" {
    description = "business_unit"
    type = string
}


variable "folder_prefix" {
    description = "folder_prefix"
    type = string
}

variable "remote_state_bucket" {
  description = "Backend bucket to load Terraform Remote State Data from previous steps."
  type        = string
}
