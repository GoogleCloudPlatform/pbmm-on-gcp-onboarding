# Create budget and alerts module
data "google_billing_account" "account" {
  billing_account = "${var.billing_account_id}"
}

resource "google_billing_budget" "budget" {
  depends_on = [ google_monitoring_notification_channel.email_channel ]
  billing_account = data.google_billing_account.account.id
  display_name   = var.budget_name
  amount   {
    specified_amount {
      currency_code = "CAD"
      units         = var.budget_amount
    }
  }      
  budget_filter {
    projects = var.budget_filter_projects
    credit_types_treatment = "INCLUDE_ALL_CREDITS"
    calendar_period = "MONTH"
  }
  threshold_rules {
    threshold_percent = var.threshold_current
    spend_basis = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = var.threshold_forecast
    spend_basis       = "FORECASTED_SPEND"
  }

  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.email_channel.id,
    ]
    disable_default_iam_recipients = true
  }
    #services = ["services/24E6-581D-38E5"] # Bigquery #OPTIONAL
    # custom_period { 
    #     start_date {
    #       year = 2022
    #       month = 1
    #       day = 1
    #     }
    #     end_date {
    #       year = 2023
    #       month = 12
    #       day = 31
    #     }
    #   }
}

resource "google_monitoring_notification_channel" "email_channel" {
  display_name = var.notification_channel_display_name
  project = var.project_id
  type         = "email"
  labels = {
    email_address = var.alert_emails
  }
}
