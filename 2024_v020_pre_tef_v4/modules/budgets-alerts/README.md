<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.
## Usage
Basic usage of this module is as follows:
```hcl
module "example" {
	 source  = "<module-path>"

	 # Required variables
	 alert_emails  = 
	 billing_account_id  = 
	 budget_amount  = 
	 budget_name  = 
	 notification_channel_display_name  = 
	 project_id  = 

	 # Optional variables
	 budget_filter_projects  = null
	 threshold_current  = 0.5
	 threshold_forecast  = 0.9
}
```
## Resources

| Name | Type |
|------|------|
| [google_billing_budget.budget](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget) | resource |
| [google_monitoring_notification_channel.email_channel](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_billing_account.account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_emails"></a> [alert\_emails](#input\_alert\_emails) | Email addresses to receive budget alerts | `string` | n/a | yes |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | ID of the billing account | `string` | n/a | yes |
| <a name="input_budget_amount"></a> [budget\_amount](#input\_budget\_amount) | Budget amount in currency | `number` | n/a | yes |
| <a name="input_budget_filter_projects"></a> [budget\_filter\_projects](#input\_budget\_filter\_projects) | Projects to include in the budget filter | `list(string)` | `null` | no |
| <a name="input_budget_name"></a> [budget\_name](#input\_budget\_name) | Display name for budget | `string` | n/a | yes |
| <a name="input_notification_channel_display_name"></a> [notification\_channel\_display\_name](#input\_notification\_channel\_display\_name) | Display Notification Channel Name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID | `string` | n/a | yes |
| <a name="input_threshold_current"></a> [threshold\_current](#input\_threshold\_current) | Current spend threshold value | `number` | `0.5` | no |
| <a name="input_threshold_forecast"></a> [threshold\_forecast](#input\_threshold\_forecast) | Forecasted spend threshold value | `number` | `0.9` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_id"></a> [budget\_id](#output\_budget\_id) | ID of the created budget |
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the created notification channel |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->