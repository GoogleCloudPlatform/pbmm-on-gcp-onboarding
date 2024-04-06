# Project Module
This modules is designed to work with the requirements for the GCP Landing
Zone and is to be used as the standard way to deploy a new GCP Project.
It is currently utilized in the Network and Bootstrap modules, and in 
the future it will be utilized to deploy application projects.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_user\_defined\_string | Additional user defined string. | `string` | `""` | no |
| auto\_create\_network | Whether to create the default network for the project | `bool` | `false` | no |
| billing\_account | Billing account id. | `string` | `null` | no |
| department\_code | Code for department, part of naming module | `string` | n/a | yes |
| environment | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| iap\_tunnel\_members\_list | list of users to grant iap.tunnelResourceAccessor role | `list(string)` | `[]` | no |
| labels | Resource labels. | `map(string)` | `{}` | no |
| location | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| oslogin | Enable OS Login. | `bool` | `false` | no |
| oslogin\_admins | List of IAM-style identities that will be granted roles necessary for OS Login administrators. | `list(string)` | `[]` | no |
| oslogin\_users | List of IAM-style identities that will be granted roles necessary for OS Login users. | `list(string)` | `[]` | no |
| owner | Division or group responsible for security and financial commitment. | `string` | n/a | yes |
| parent | Parent folder or organization in 'folders/folder\_id' or 'organizations/org\_id' format. | `string` | `null` | no |
| policy\_boolean | Map of boolean org policies and enforcement value, set value to null for policy restore. | `map(bool)` | `{}` | no |
| policy\_list | Map of list org policies, status is true for allow, false for deny, null for restore. Values can only be used for allow or deny. | <pre>map(object({<br>    inherit_from_parent = bool<br>    suggested_value     = string<br>    status              = bool<br>    values              = list(string)<br>  }))</pre> | `{}` | no |
| service\_config | Configure service API activation. | <pre>object({<br>    disable_on_destroy         = bool<br>    disable_dependent_services = bool<br>  })</pre> | <pre>{<br>  "disable_dependent_services": true,<br>  "disable_on_destroy": true<br>}</pre> | no |
| services | Service APIs to enable. | `list(string)` | `[]` | no |
| shared\_vpc\_host\_config | Configures this project as a Shared VPC host project (mutually exclusive with shared\_vpc\_service\_project). | `bool` | `false` | no |
| shared\_vpc\_service\_config | Configures this project as a Shared VPC service project (mutually exclusive with shared\_vpc\_host\_config). | <pre>object({<br>    attach       = bool<br>    host_project = string<br>  })</pre> | <pre>{<br>  "attach": false,<br>  "host_project": ""<br>}</pre> | no |
| user\_defined\_string | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | Project name. |
| number | Project number. |
| project\_id | Project id. |
| service\_accounts | Product robot service accounts in project. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->