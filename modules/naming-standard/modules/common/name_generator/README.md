# Overview
This module generates the GC prefix naming for GCP resource naming.



# Limitations


# Known Issues


# Usage
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| device\_type | Three character string. The SSC SACM end-state naming convention for CMDB and DNS compliance. | `string` | `""` | no |
| gc\_prefix | GC governance prefix. | `string` | n/a | yes |
| name\_sections | Key Value pairs of naming sections for text replacement. | `map(any)` | n/a | yes |
| type | For supported types see ./config/resource\_naming\_patterns.yaml and ./config/resource\_types.yaml for codes. | `string` | n/a | yes |
| type\_parent | For type parents see ./config/resource\_naming\_patterns.yaml and ./config/resource\_types.yaml for codes. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| device\_type | The resource's device type code. |
| prefix | The name's prefix. |
| result | name |
| result\_without\_type | name without type |
| type | The resource type code. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
