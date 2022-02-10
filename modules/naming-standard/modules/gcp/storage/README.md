# Overview
This module generates the GC naming convention for the `storage bucket`.

This module purely follows the GC naming conventions to allow the caller to
generate their own unique 'user_defined_string'.

To have a generated storage account name with a max of 24 characters, use
module `module/az/storage_account_name_generator`.

# Limitations

# Known Issues

# Usage
For sample usage, refer to base [README.md](../../../README.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| department\_code | Two character department code. Format: Uppercase lowercase e.g. Sc. | `string` | n/a | yes |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | n/a | yes |
| location | CSP and Region. Valid values: e = northamerica-northeast1 | `string` | n/a | yes |
| user\_defined\_string | User defined string for the storage account, must a a unique value of lower-case letters or numbers with a maximum length of 20 characters. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| csp\_region\_code | Provides the csp\_region code from the GCP location. |
| device\_type | The resource's device type code. |
| prefix | The name's prefix. |
| result | Provides naming convention defined by the `SSC Naming and Tagging Standard for GCP` document. |
| result\_without\_type | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| type | The resource type code. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
