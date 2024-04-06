module "budget_and_alerts" {
  source                    = "./budgets-alerts"
  project_id                = "your-project-id"
  budget_name               = "mybudget"
  budget_amount             = 1000
  budget_filter_projects    = ["projects/403939141234","projects/509145981234"]
  threshold_current         = 0.5
  threshold_forecast        = 0.9
  alert_emails              = "apple.adams@domain.com"
  billing_account_id        = "your-billing-account-id"
  notification_channel_display_name = "my_notification_channel_name"
}