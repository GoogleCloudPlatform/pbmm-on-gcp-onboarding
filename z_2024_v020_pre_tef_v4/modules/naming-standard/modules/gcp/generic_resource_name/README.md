# Overview
This module generates the GC naming convention for any resource with a generic naming scheme
defined by the `SSC-GCP Naming` documentation as:
`<Dept. Code><env><CSP region><device type>-<user_defined_string>-<suffix>`

Use this naming module when the resource is not defined to have a naming pattern that different from the generic naming scheme
and if the resource is not available in `modules/gcp/<resource_name>`.

It is also possible that the resource naming module has not been created yet.
Refer to base [README.md](../../../README.md) to developer instructions on how to add more naming modules.

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
| device\_type | Three character string. The SSC SACM end-state naming convention for CMDB and DNS compliance. | `string` | n/a | yes |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | n/a | yes |
| location | CSP and Region. Valid values: c = canadacentral, d = canadaeast | `string` | n/a | yes |
| resource\_type | The resource type code, appended to the resource's name. | `string` | n/a | yes |
| user\_defined\_string | User defined string. | `string` | n/a | yes |

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
