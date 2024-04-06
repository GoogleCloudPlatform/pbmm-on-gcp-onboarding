variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "budget_amount" {
  description = "Budget amount in currency"
  type        = number
}

variable "alert_emails" {
  description = "Email addresses to receive budget alerts"
  type        = string
}

variable "budget_filter_projects" {
  description = "Projects to include in the budget filter"
  type        = list(string)
  default = null
  }

variable "billing_account_id" {
  description = "ID of the billing account"
  type        = string
}

variable "budget_name" {
  description = "Display name for budget"
  type        = string
}

variable "notification_channel_display_name" {
  description = "Display Notification Channel Name"
  type        = string
}
variable "threshold_current" {
  description = "Current spend threshold value"
  type        = number
  default     =  0.5
}
variable "threshold_forecast" {
  description = "Forecasted spend threshold value"
  type        = number
  default     =  0.9
}

