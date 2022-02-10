# terraform-guardrails
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_user\_defined\_string | Environment modifier to deploy multiple instances | `string` | `""` | no |
| billing\_account | Billing account id. | `string` | `null` | no |
| department\_code | The Department Code Used for Naming Purposes. | `string` | n/a | yes |
| environment | P = Prod, D = Development, Q = QA, S = SandBox, etc. | `string` | n/a | yes |
| org\_client | True if this is a client organization. False if this is the core organization. | `bool` | `false` | no |
| org\_id | The organization ID this will be deployed to | `string` | n/a | yes |
| org\_id\_scan\_list | A list of organization\_id's to scan. | `list(string)` | `[]` | no |
| owner | Owner of the project | `string` | `""` | no |
| parent | Parent folder or organization in 'folders/folder\_id' or 'organizations/org\_id' format to create the guardrails in. | `string` | `null` | no |
| region | The default region of all resources. | `string` | `"northamerica-northeast1"` | no |
| user\_defined\_string | Environment modifier to deploy multiple instances | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| asset\_inventory\_bucket | GCS bucket containing the asset inventory report dumps |
| cloudbuild\_container\_pipeline\_definition | The Cloud Build Trigger that builds the report generation container |
| cloudbuild\_container\_pipeline\_trigger | The Cloud Build Trigger that builds the report generation container |
| guardrails\_container\_location | The Cloud Build Trigger that builds the report generation container |
| guardrails\_policies\_repo\_name | The name of the repository containing the guardrails rego policies in Cloud Source Repository |
| project\_id | The Project ID of the guardrails resources have been deployed to |
| report\_generation\_schedule | The schedule of the report generation. |
| reports\_bucket | GCS bucket containing the guardrails reports of the scan results |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->