# terraform-dns-zone
Terraform module to createa and manage DNS zones in GCP

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.forwarding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_managed_zone.peering](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_managed_zone.private](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_managed_zone.public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.cloud-static-records](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_key_specs_key"></a> [default\_key\_specs\_key](#input\_default\_key\_specs\_key) | Key Signing Object : algorithm, key\_length, key\_type, kind. See https://cloud.google.com/dns/docs/reference/v1/managedZones for valid values for each field. | `any` | `{}` | no |
| <a name="input_default_key_specs_zone"></a> [default\_key\_specs\_zone](#input\_default\_key\_specs\_zone) | Zone Signing Object : algorithm, key\_length, key\_type, kind. See https://cloud.google.com/dns/docs/reference/v1/managedZones for valid values for each field. | `any` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of Managed Zone | `string` | n/a | yes |
| <a name="input_dnssec_config"></a> [dnssec\_config](#input\_dnssec\_config) | Object containing : kind, non\_existence, state. See https://cloud.google.com/dns/docs/reference/v1/managedZones for valid kind, non\_existence and state values. | `any` | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Zone domain, must end with a period. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Set this true to delete all records in the zone. | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key value pairs for labels for the Managed Zone. | `map(any)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Zone name, must be unique within the project. | `string` | n/a | yes |
| <a name="input_private_visibility_config_networks"></a> [private\_visibility\_config\_networks](#input\_private\_visibility\_config\_networks) | List of VPC self links that can see this zone. | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id for the zone. | `string` | n/a | yes |
| <a name="input_recordsets"></a> [recordsets](#input\_recordsets) | List of DNS record objects to manage, in the standard terraform dns structure. | <pre>list(object({<br>    name    = string<br>    type    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_target_name_server_addresses"></a> [target\_name\_server\_addresses](#input\_target\_name\_server\_addresses) | List of target name servers for forwarding zone. | `list(map(any))` | `[]` | no |
| <a name="input_target_network"></a> [target\_network](#input\_target\_network) | Peering network. | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | public, private, forwarding or peering. | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain"></a> [domain](#output\_domain) | The DNS zone domain. |
| <a name="output_name"></a> [name](#output\_name) | The DNS zone name. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The DNS zone name servers. |
| <a name="output_type"></a> [type](#output\_type) | The DNS zone type. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->