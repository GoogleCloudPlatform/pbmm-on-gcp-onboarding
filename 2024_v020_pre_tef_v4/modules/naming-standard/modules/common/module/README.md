# Overview
This folder contains common templates to be used when creating a naming module for a resource type. These templates can be symlinked in the resource folder.

Templates:
* `common.tf`
* `common_bypass_prefix.tf` - Used for resources that have a parent. The prefix will be assumed from the parent instead of regenerating it. This help reduce the number of input parameters passed into the naming module.
* `common_mod_extend.tf`
* `common_optional_prefix`

# Usage
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| department\_code | Two character department code. Format: Uppercase lowercase e.g. Sc. | `string` | `""` | no |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | `""` | no |
| location | CSP and Region. Valid values: e = northamerica-northeast1 | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| csp\_region\_code | Provides the csp\_region code from the gcpure location. |
| device\_type | The resource's device type code. |
| prefix | The name's prefix. |
| result | Provides naming convention defined by the `SSC Naming and Tagging Standard for GCP` document. |
| result\_without\_type | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| type | The resource type code. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
