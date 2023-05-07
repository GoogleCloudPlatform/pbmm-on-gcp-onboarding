# Overview
This module generates the GC naming convention for a `route`.

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
| user\_defined\_string | Routes can be used in multiple route tables.<br>The naming convention is defined by the cloud network team or resource owner of the route.<br>e.g. The PBMM VDC uses the following syntax: `to<device>_<source>_<destination>.` | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| device\_type | The resource's device type code. |
| prefix | The name's prefix. |
| result | Provides naming convention defined by the `SSC Naming and Tagging Standard for Azure` document. |
| result\_without\_type | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| type | The resource type code. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
