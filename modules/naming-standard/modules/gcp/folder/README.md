# Overview
This module generates the GC naming convention for the folders.

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
| department\_code | Two character department code. Format: Uppercase lowercase e.g. Sc. | `string` | `""` | no |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | `""` | no |
| location | CSP and Region. Valid values: e = northamericanortheast1 | `string` | `""` | no |
| owner | Division or group responsible for security and financial commitment. | `string` | `""` | no |
| project | Short string selected by the resource owner (aka user\_defined\_string). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| device\_type | The resource's device type code. |
| prefix | The name's prefix. |
| result | Provides naming convention defined by the `SSC Naming and Tagging Standard for GCP` document. |
| result\_without\_type | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| type | The resource type code. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
