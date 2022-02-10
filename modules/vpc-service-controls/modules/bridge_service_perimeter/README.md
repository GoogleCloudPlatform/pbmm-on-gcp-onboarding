# Access Bridge Submodule

This module handles opiniated configuration and deployment of a [access_context_manager_service_perimeter](https://www.terraform.io/docs/providers/google/r/access_context_manager_service_perimeter.html) resource for bridge service perimeter types.

## Usage
```hcl
module "bridge_service_perimeter_1" {
  source         = "."
  policy         = var.policy_id
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources = ["project-1-id","project-2-id"]
}

module "regular_service_perimeter_1" {
  source         = "."
  policy         = var.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["project-2-id"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
}

module "regular_service_perimeter_2" {
  source         = "."
  policy         = var.policy_id
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = ["project-2-id"]

  restricted_services = ["storage.googleapis.com"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | Description of the bridge perimeter | `string` | `""` | no |
| perimeter\_name | Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores | `string` | n/a | yes |
| policy | Name of the parent policy | `string` | n/a | yes |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. | `list(string)` | n/a | yes |
| resources\_by\_numbers | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | names of the service perimeters |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->