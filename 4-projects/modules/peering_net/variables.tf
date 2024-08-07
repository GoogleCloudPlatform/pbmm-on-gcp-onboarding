variable "env" {
  description = "The environment to prepare (ex. development)."
  type        = string
}

variable "peering_module_depends_on" {
  description = "List of modules or resources peering module depends on."
  type        = list(any)
  default     = []
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  //  default     = true
}

variable "optional_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of optional firewall rules: Internal & Global load balancing health check and load balancing IP ranges."
  //  default     = false
}

variable "windows_activation_enabled" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads."
  //  default     = false
}

variable "vpc_flow_logs" {
  description = <<EOT
  aggregation_interval: Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Possible values are: INTERVAL_5_SEC, INTERVAL_30_SEC, INTERVAL_1_MIN, INTERVAL_5_MIN, INTERVAL_10_MIN, INTERVAL_15_MIN.
  flow_sampling: Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported. The value of the field must be in [0, 1].
  metadata: Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are: EXCLUDE_ALL_METADATA, INCLUDE_ALL_METADATA, CUSTOM_METADATA.
  metadata_fields: ist of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is enabled and "metadata" is set to CUSTOM_METADATA.
  filter_expr: Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field.
EOT
  type = object({
    aggregation_interval = optional(string, "INTERVAL_5_SEC")
    flow_sampling        = optional(string, "0.5")
    metadata             = optional(string, "INCLUDE_ALL_METADATA")
    metadata_fields      = optional(list(string), [])
    filter_expr          = optional(string, "true")
  })
  default = {}
}

variable "project_budget" {
  description = <<EOT
  Budget configuration.
  budget_amount: The amount to use as the budget.
  alert_spent_percents: A list of percentages of the budget to alert on when threshold is exceeded.
  alert_pubsub_topic: The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}`.
  alert_spend_basis: The type of basis used to determine if spend has passed the threshold. Possible choices are `CURRENT_SPEND` or `FORECASTED_SPEND` (default).
  EOT
  type = object({
    budget_amount        = optional(number, 1000)
    alert_spent_percents = optional(list(number), [1.2])
    alert_pubsub_topic   = optional(string, null)
    alert_spend_basis    = optional(string, "FORECASTED_SPEND")
  })
  default = {}
}

variable "peering_iap_fw_rules_enabled" {
  description = "Toggle creation of optional IAP firewall rules: SSH, RDP."
  type        = bool
  //  default     = false
}

variable "business_code" {
  description = "The business code (ex. bu1)."
  type        = string
}

variable "peering_project_id" {
  description = "Peering project ID"
  type        = string
}

variable "peer_network_self_link" {
  description = "network self link"
  type        = string
}

variable "subnet_config" {
  description = "subnet_info"
  type        = any
}
