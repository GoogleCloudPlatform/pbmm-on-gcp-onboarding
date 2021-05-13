variable "project_id" {
  description = "The ID of the project in which the log export will be created."
  type        = string
}

variable "parent_resource_id" {
  description = "The ID of the project in which BigQuery dataset destination will be created."
  type        = string
}
