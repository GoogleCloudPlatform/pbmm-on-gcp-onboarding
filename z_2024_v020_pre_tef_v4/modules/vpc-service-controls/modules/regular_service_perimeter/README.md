# Access Perimeter Submodule

This module handles opiniated configuration and deployment of a [access_context_manager_service_perimeter](https://www.terraform.io/docs/providers/google/r/access_context_manager_service_perimeter.html) resource for regular service perimeter types.

## Usage
```hcl
module "regular_service_perimeter_1" {
  source         = "."
  policy         = var.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["project-1-id"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_levels | A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY\_POLICY/accessLevels/MY\_LEVEL'. For Service Perimeter Bridge, must be empty. | `list(string)` | `[]` | no |
| access\_levels\_dry\_run | (Dry-run) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY\_POLICY/accessLevels/MY\_LEVEL'. For Service Perimeter Bridge, must be empty. If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| description | Description of the regular perimeter | `string` | n/a | yes |
| dry\_run | enable the dry run parameters | `bool` | `false` | no |
| live\_run | enable the dry run parameters | `bool` | `false` | no |
| perimeter\_name | Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores | `any` | n/a | yes |
| policy | Name of the parent policy | `string` | n/a | yes |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. | `list(string)` | `[]` | no |
| resources\_by\_numbers | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. | `list(string)` | `[]` | no |
| resources\_dry\_run | (Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| resources\_dry\_run\_by\_numbers | (Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| restricted\_services | GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions. | `list(string)` | `[]` | no |
| restricted\_services\_dry\_run | (Dry-run) GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions.  If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| vpc\_accessible\_services | only if you want to add VPC accessible services when you create the perimeter. Comma-separated list of one or more services that you want to allow networks inside your perimeter to access. Access to any services that are not included in this list will be prevented. | <pre>object({<br>    enable_restriction = bool,<br>    allowed_services   = list(string),<br>  })</pre> | <pre>{<br>  "allowed_services": [<br>    "RESTRICTED-SERVICES"<br>  ],<br>  "enable_restriction": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| name | names of the service perimeters |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->