# GCP IAM Module

The purpose of this module is to set create project service accounts and assign permissions to them. It also is used to assign permissions to non-project service accounts and users to project resources. 

## Currently supported
- Creation of Project service accounts and role assignments to them
- Assignment of roles to Service Accounts, Groups and Users that do not belong to the current project
- Assignment of the `compute.networkUser` role on a specified network project to a specified subnet

## Future enhancements
In the future it should be expanded to include
- Big Query Datasets
- Pub/Sub resources
- Buckets
- Any other resource where permissions can be assigned at the resource level


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute_network_users"></a> [compute\_network\_users](#module\_compute\_network\_users) | ./modules/compute_network_user | n/a |
| <a name="module_folder_iam"></a> [folder\_iam](#module\_folder\_iam) | ./modules/folder_iam | n/a |
| <a name="module_organization_iam"></a> [organization\_iam](#module\_organization\_iam) | ./modules/organization_iam | n/a |
| <a name="module_project_iam"></a> [project\_iam](#module\_project\_iam) | ./modules/project_iam | n/a |
| <a name="module_sa_create_assign"></a> [sa\_create\_assign](#module\_sa\_create\_assign) | ./modules/sa_create_assign | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_network_users"></a> [compute\_network\_users](#input\_compute\_network\_users) | List of accounts that exist outside the project to grant roles to within the project | <pre>list(object({<br>    members    = list(string)<br>    subnetwork = string<br>    region     = string<br>    project    = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_folder_iam"></a> [folder\_iam](#input\_folder\_iam) | List of accounts to grant roles to on a specified folder/######## | <pre>list(object({<br>    member = string<br>    roles  = list(string)<br>    folder = string<br>  }))</pre> | `[]` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization to apply changes to | `string` | `null` | no |
| <a name="input_organization_iam"></a> [organization\_iam](#input\_organization\_iam) | List of accounts to grant roles to with to the organizations/####### | <pre>list(object({<br>    member       = string<br>    roles        = list(string)<br>    organization = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project to apply changes to | `string` | `null` | no |
| <a name="input_project_iam"></a> [project\_iam](#input\_project\_iam) | List of accounts that exist outside the project to grant roles to within the project | <pre>list(object({<br>    member  = string<br>    roles   = list(string)<br>    project = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_sa_create_assign"></a> [sa\_create\_assign](#input\_sa\_create\_assign) | List of service accounts to create and roles to assign to them | <pre>list(object({<br>    account_id   = string<br>    display_name = string<br>    roles        = list(string)<br>    project      = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compute_network_users"></a> [compute\_network\_users](#output\_compute\_network\_users) | n/a |
| <a name="output_folder_iam_members"></a> [folder\_iam\_members](#output\_folder\_iam\_members) | n/a |
| <a name="output_organization_iam_members"></a> [organization\_iam\_members](#output\_organization\_iam\_members) | n/a |
| <a name="output_project_iam_members"></a> [project\_iam\_members](#output\_project\_iam\_members) | n/a |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->