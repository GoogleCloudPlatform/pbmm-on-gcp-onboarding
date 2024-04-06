# Audit Log Bunker
This modules is designed to work with the requirements for the GCP Landing
Zone and is used to satisfy the 30-Day Guardrail requirement for storing unaltered logs.

This module creates an audit project with one or many Organization Log Sinks,
and Buckets which can be filtered to store specific logs.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_audit"></a> [audit](#module\_audit) | ./modules/audit | n/a |
| <a name="module_audit_project"></a> [audit\_project](#module\_audit\_project) | ../project | 1.3.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_user_defined_string"></a> [additional\_user\_defined\_string](#input\_additional\_user\_defined\_string) | Additional user defined string. | `string` | `""` | no |
| <a name="input_audit_streams"></a> [audit\_streams](#input\_audit\_streams) | Map of buckets to store audit logs | `map(any)` | n/a | yes |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing account id. | `string` | `null` | no |
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | The Department Code Used for Naming Purposes. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | P = Prod, N = NonProd, S = SandBox, etc. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | ID of organization place sink in | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner of the project | `string` | `""` | no |
| <a name="input_parent"></a> [parent](#input\_parent) | Parent folder or organization in 'folders/folder\_id' or 'organizations/org\_id' format. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Bucket Region | `string` | n/a | yes |
| <a name="input_user_defined_string"></a> [user\_defined\_string](#input\_user\_defined\_string) | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_sinks"></a> [log\_sinks](#output\_log\_sinks) | Org log sinks |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Audit project ID |
| <a name="output_sink_buckets"></a> [sink\_buckets](#output\_sink\_buckets) | Sink buckets |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
