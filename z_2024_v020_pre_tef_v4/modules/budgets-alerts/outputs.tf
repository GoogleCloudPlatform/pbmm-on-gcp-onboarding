output "budget_id" {
  description = "ID of the created budget"
  value       = google_billing_budget.budget.id
}

# output "alert_policy_id" {
#   description = "ID of the created alert policy"
#   value       = google_monitoring_alert_policy.budget_alert.name
# }

output "notification_channel_id" {
  description = "ID of the created notification channel"
  value       = google_monitoring_notification_channel.email_channel.name
}
