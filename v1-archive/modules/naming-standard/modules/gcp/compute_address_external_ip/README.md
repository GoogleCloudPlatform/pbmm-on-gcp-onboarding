# Overview
This module generates the GC naming convention for the `compute_address_external_ip`.

# Limitations

# Known Issues

# Usage
For sample usage, refer to base [README.md](../../../README.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_prefix"></a> [common\_prefix](#module\_common\_prefix) | ../../common/gc_prefix | n/a |
| <a name="module_name_generation"></a> [name\_generation](#module\_name\_generation) | ../../common/name_generator | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | Two character department code. Format: Uppercase lowercase e.g. Sc. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | CSP and Region. Valid values: e = northamerica-northeast1 | `string` | n/a | yes |
| <a name="input_user_defined_string"></a> [user\_defined\_string](#input\_user\_defined\_string) | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_csp_region_code"></a> [csp\_region\_code](#output\_csp\_region\_code) | Provides the csp\_region code from the GCP location. |
| <a name="output_device_type"></a> [device\_type](#output\_device\_type) | The resource's device type code. |
| <a name="output_prefix"></a> [prefix](#output\_prefix) | The name's prefix. |
| <a name="output_result"></a> [result](#output\_result) | Provides naming convention. |
| <a name="output_result_lower"></a> [result\_lower](#output\_result\_lower) | Provides naming convention. Lower case to meet GCP requirements |
| <a name="output_result_without_type"></a> [result\_without\_type](#output\_result\_without\_type) | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| <a name="output_type"></a> [type](#output\_type) | The resource type code. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
