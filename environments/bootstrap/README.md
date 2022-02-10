# Landing Zone Bootstrap Project
This modules is designed to work with the requirements for the [GCP Landing
Zone](https://bitbucket.org/sourcedgroup/gcp-foundations-live-infra). 

This module provides:
- Bootstrap Project
- Cloud Build
- Service account used to deploy Landing Zone infrastructure
- Set roles on the SA
- Buckets used to store Terraform State
- Permissions on bucket for a user to upload the Bootstrap Terraform state.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_user\_defined\_string | Additional user defined string. | `string` | `""` | no |
| billing\_account | billing account ID | `string` | n/a | yes |
| bootstrap\_email | Email of user:me@domain.com or group:us@domain.com to apply permissions to upload the state to the bucket once project as been created | `string` | n/a | yes |
| default\_region | n/a | `string` | `"northamerica-northeast1"` | no |
| department\_code | Code for department, part of naming module | `string` | n/a | yes |
| environment | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| location | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| org\_id | ID alone in the for of ##### to create the deploy account | `string` | n/a | yes |
| owner | Division or group responsible for security and financial commitment. | `string` | n/a | yes |
| parent | folder/#### or organizations/### to place the project into | `string` | n/a | yes |
| sa\_org\_iam\_permissions | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | `[]` | no |
| services | List of services to enable on the bootstrap project required for using their APIs | `list(string)` | n/a | yes |
| set\_billing\_iam | Disable for unit test as the SA is a Billing User. Requires Billing Administrator | `bool` | `true` | no |
| terraform\_deployment\_account | Service Account name | `string` | n/a | yes |
| tfstate\_buckets | Map of buckets to store Terraform state files | <pre>map(<br>    object({<br>      name          = string,<br>      labels        = optional(map(string)),<br>      force_destroy = optional(bool),<br>      storage_class = optional(string),<br>    })<br>  )</pre> | n/a | yes |
| user\_defined\_string | User defined string. | `string` | n/a | yes |
| yaml\_config\_bucket | Map with config bucket params | <pre>object({<br>    name          = string,<br>    labels        = optional(map(string)),<br>    force_destroy = optional(bool),<br>    storage_class = optional(string),<br>  })</pre> | n/a | yes |
| yaml\_config\_bucket\_writers | list of Groups/SA/Users in the form of user:me@domain.com | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | n/a |
| service\_account\_email | n/a |
| tfstate\_bucket\_names | n/a |
| yaml\_config\_bucket | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->