# GCP Firewall Module
This modules is designed to work with the requirements for the GCP Landing Zone.

The module has the following rules defined but does allow for custom rules
to override them.
- Deny all ingress (high priority rule)
- Deny all egress (high priority rule)
- Allow traffic from one resource to another within a zone
- Deny all traffic between zones
- Allow all egress from resources tagged with 'public-zone'

For a list of zones see the 'zone_list' input variable.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_allow_admins_name"></a> [allow\_admins\_name](#module\_allow\_admins\_name) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |
| <a name="module_allow_internal_name"></a> [allow\_internal\_name](#module\_allow\_internal\_name) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |
| <a name="module_allow_zone_internal_ingress_name"></a> [allow\_zone\_internal\_ingress\_name](#module\_allow\_zone\_internal\_ingress\_name) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |
| <a name="module_bastion_rule_name"></a> [bastion\_rule\_name](#module\_bastion\_rule\_name) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |
| <a name="module_custom_rules_names"></a> [custom\_rules\_names](#module\_custom\_rules\_names) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |
| <a name="module_deny_all_egress_name"></a> [deny\_all\_egress\_name](#module\_deny\_all\_egress\_name) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |
| <a name="module_iap_rules_names"></a> [iap\_rules\_names](#module\_iap\_rules\_names) | ../terraform-gc-naming//modules/gcp/firewall_rule | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow-admins](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow-internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow-zone-internal-ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.bastian_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.custom](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.custom_iap_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.deny-all-egress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ranges"></a> [admin\_ranges](#input\_admin\_ranges) | IP CIDR ranges that have complete access to all subnets. | `list(string)` | `[]` | no |
| <a name="input_admin_ranges_enabled"></a> [admin\_ranges\_enabled](#input\_admin\_ranges\_enabled) | Enable admin ranges-based rules. | `bool` | `false` | no |
| <a name="input_custom_iap_rules"></a> [custom\_iap\_rules](#input\_custom\_iap\_rules) | Object of rules to add to the firewall for IAP access to custom ports | <pre>map(object({<br>    rule_name = string<br>    protocol  = string<br>    ports     = list(string)<br>    })<br>  )</pre> | `{}` | no |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | List of custom rule definitions (refer to variables file for syntax). | <pre>map(object({<br>    description          = string<br>    direction            = string<br>    action               = string # (allow|deny)<br>    ranges               = list(string)<br>    sources              = list(string)<br>    targets              = list(string)<br>    use_service_accounts = bool<br>    rules = list(object({<br>      protocol = string<br>      ports    = list(string)<br>    }))<br>    extra_attributes = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | The Department Code Used for Naming Purposes. | `string` | n/a | yes |
| <a name="input_enable_bastion_ports"></a> [enable\_bastion\_ports](#input\_enable\_bastion\_ports) | enable IAP via ports 22 and 3389 | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | P = Prod, N = NonProd, S = SandBox, etc. | `string` | n/a | yes |
| <a name="input_internal_allow"></a> [internal\_allow](#input\_internal\_allow) | Allow rules for internal ranges. | `list` | <pre>[<br>  {<br>    "protocol": "icmp"<br>  }<br>]</pre> | no |
| <a name="input_internal_ranges"></a> [internal\_ranges](#input\_internal\_ranges) | IP CIDR ranges for intra-VPC rules. | `list(string)` | `[]` | no |
| <a name="input_internal_ranges_enabled"></a> [internal\_ranges\_enabled](#input\_internal\_ranges\_enabled) | Create rules for intra-VPC ranges. | `bool` | `false` | no |
| <a name="input_internal_target_tags"></a> [internal\_target\_tags](#input\_internal\_target\_tags) | List of target tags for intra-VPC rules. | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | location for naming purposes. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Name of the network this set of firewall rules applies to. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id of the project that holds the network. | `string` | n/a | yes |
| <a name="input_zone_list"></a> [zone\_list](#input\_zone\_list) | List of all zone where all communicaiton within the zone itself is allow, traffic to other zones still requires other rules | `list(any)` | <pre>[<br>  "public-access-zone",<br>  "operations-zone",<br>  "restricted-zone",<br>  "management-restricted-zone"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_egress_allow_rules"></a> [custom\_egress\_allow\_rules](#output\_custom\_egress\_allow\_rules) | Custom egress rules with allow blocks. |
| <a name="output_custom_egress_deny_rules"></a> [custom\_egress\_deny\_rules](#output\_custom\_egress\_deny\_rules) | Custom egress rules with allow blocks. |
| <a name="output_custom_ingress_allow_rules"></a> [custom\_ingress\_allow\_rules](#output\_custom\_ingress\_allow\_rules) | Custom ingress rules with allow blocks. |
| <a name="output_custom_ingress_deny_rules"></a> [custom\_ingress\_deny\_rules](#output\_custom\_ingress\_deny\_rules) | Custom ingress rules with deny blocks. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->