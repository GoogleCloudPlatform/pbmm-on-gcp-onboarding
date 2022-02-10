# Overview
This module generates the GC naming convention for virtual machines `instance group`.

For device types, refer to this yaml file:
[<repo_root>/configs/device_types.yaml](../../../configs/device_types.yaml).


For server codes for the SRV device type, refer this yaml file:
[<repo_root>/configs/server.yaml](../../../configs/server.yaml).

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
| device\_type | Three character string. | `string` | n/a | yes |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | n/a | yes |
| location | CSP and Region. Valid values: e = northamerica-northeast1 | `string` | n/a | yes |
| user\_defined\_string | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| csp\_region\_code | Provides the csp\_region code from the GCP location. |
| device\_type | The resource's device type code. |
| prefix | The name's prefix. |
| result | Provides naming convention. |
| result\_lower | Provides naming convention. Lower case to meet GCP requirements |
| result\_without\_type | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| type | The resource type code. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->