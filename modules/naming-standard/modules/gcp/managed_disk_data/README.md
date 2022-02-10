# Overview
This module generates the GC naming convention for the `managed disk os`.

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
| <a name="module_name_generation"></a> [name\_generation](#module\_name\_generation) | ../../common/name_generator | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_number_suffix"></a> [number\_suffix](#input\_number\_suffix) | Number suffix for the resource name. | `string` | `"1"` | no |
| <a name="input_parent_resource"></a> [parent\_resource](#input\_parent\_resource) | VM full name. Create parent resource name first and use output `result`. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_device_type"></a> [device\_type](#output\_device\_type) | The resource's device type code. |
| <a name="output_prefix"></a> [prefix](#output\_prefix) | The name's prefix. |
| <a name="output_result"></a> [result](#output\_result) | Provides naming convention. |
| <a name="output_result_lower"></a> [result\_lower](#output\_result\_lower) | Provides naming convention in lower case to match GCP Standards |
| <a name="output_result_without_type"></a> [result\_without\_type](#output\_result\_without\_type) | Provides the name of the resource minus the resource type suffix, if present. Can be used for parent names for child resources. |
| <a name="output_type"></a> [type](#output\_type) | The resource type code. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->