# Overview
This module generates the GC naming convention for the `subnet`.

NOTE: The common_for_subnet.tf is not symlinked to `../../common/module/common.tf` like other modules. We have
to override the output if the subnet names passed in using `user_defined_string` are reserved names.
Since no other resource types have this type of logic requirement, I coded the exception locally to
`subnet/` rather than defining another common pattern.

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
| additional\_user\_defined\_string | User defined string for the subnet. | `string` | n/a | yes |
| department\_code | Two character department code. Format: Uppercase lowercase e.g. Sc. | `string` | n/a | yes |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | n/a | yes |
| location | CSP and Region. Valid values: e = northamerica-northeast1 | `string` | n/a | yes |
| user\_defined\_string | User defined string for the vpc. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| csp\_region\_code | Provides the csp\_region code from the Azure location. |
| result | Provides naming convention defined by the `SSC Naming and Tagging Standard for Azure` document. |
| result\_without\_type | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
