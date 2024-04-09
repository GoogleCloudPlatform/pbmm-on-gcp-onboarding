# Overview
This module has been engineered to be used as part of the GCP Landing Zone. It creates custom roles at the Organization
level that can be assigned at the Organization, Folder or Project level.

## Limitations

## Known Issues

None

## Usage

See the [examples](examples/main.tf) folder.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.62.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom_role_names"></a> [custom\_role\_names](#module\_custom\_role\_names) | ../naming-standard//modules/gcp/custom_role | 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_custom_role.org_custom_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_custom_role) | resource |
| [random_id.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Map of roles to create | <pre>map(<br>    object({<br>      title       = string<br>      description = string<br>      role_id     = string<br>      permissions = list(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | Code for department, part of naming module | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization to create the custom role in | `string` | n/a | yes |
| <a name="input_user_defined_string"></a> [user\_defined\_string](#input\_user\_defined\_string) | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_ids"></a> [role\_ids](#output\_role\_ids) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
