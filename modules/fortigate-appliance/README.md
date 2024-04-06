# Fortigate Active-Passive HA Cluster

Please refer to the document [FortiGate NGFW HA solution guide](../docs/fortigate-ngfw-ha-cluster-guide.md) for more information about how to plan, design, deploy and configurate your FortiGate firewall solution.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute_address_internal_active_ip"></a> [compute\_address\_internal\_active\_ip](#module\_compute\_address\_internal\_active\_ip) | ../naming-standard//modules/gcp/compute_address_internal_ip | n/a |
| <a name="module_compute_address_internal_passive_ip"></a> [compute\_address\_internal\_passive\_ip](#module\_compute\_address\_internal\_passive\_ip) | ../naming-standard//modules/gcp/compute_address_internal_ip | n/a |
| <a name="module_compute_address_public_active_ip"></a> [compute\_address\_public\_active\_ip](#module\_compute\_address\_public\_active\_ip) | ../naming-standard//modules/gcp/compute_address_external_ip | n/a |
| <a name="module_compute_address_public_passive_ip"></a> [compute\_address\_public\_passive\_ip](#module\_compute\_address\_public\_passive\_ip) | ../naming-standard//modules/gcp/compute_address_external_ip | n/a |
| <a name="module_fortigate_service_account"></a> [fortigate\_service\_account](#module\_fortigate\_service\_account) | ../naming-standard//modules/gcp/service_account | n/a |
| <a name="module_unmanaged_instance_group"></a> [unmanaged\_instance\_group](#module\_unmanaged\_instance\_group) | ../naming-standard//modules/gcp/virtual_machine_instance_group | n/a |
| <a name="module_vm_name"></a> [vm\_name](#module\_vm\_name) | ../naming-standard//modules/gcp/virtual_machine | n/a |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_image.fortios_image_gvnic](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_image) | resource |
| [google_compute_address.active](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.active_instance_mgmt_sip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.cluster_sip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.external_ilbnh_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.internal_ilbnh_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.passive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.passive_instance_mgmt_sip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.public_active](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.public_passive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_firewall.allow_fgt_external_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_fgt_public_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ftg_healthchecks_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ftg_internal_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ftg_internet_egress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ftg_mgmt_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ftg_sync_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_internal_internet_egress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_public_internet_egress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_forwarding_rule.external_ilbnh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_forwarding_rule.external_passthrough_nlb](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_forwarding_rule.internal_ilbnh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_health_check.ilbnh_common](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_http_health_check.external_passthrough_nlb_healthcheck](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_http_health_check) | resource |
| [google_compute_instance_from_template.fgtvm_instances](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template) | resource |
| [google_compute_instance_group.fgtvm_umigs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group) | resource |
| [google_compute_instance_template.ftgvm_instance_templates](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_region_backend_service.external_ilbnh_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_compute_region_backend_service.internal_ilbnh_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_compute_route.external_default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_route.internal_default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_router.public_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.public_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_target_pool.external_passthrough_nlb_targetpool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_pool) | resource |
| [google_project_iam_member.fortigate_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.internal_network_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.fortigate_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [random_password.fgt_ha_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.random_name_post](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_compute_subnetwork.subnetworks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |
| [template_file.metadata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_acl"></a> [admin\_acl](#input\_admin\_acl) | List of CIDRs allowed to connect to FortiGate management interfaces. Defaults to 0.0.0.0/0 | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | Code for department, part of naming module | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| <a name="input_ha_port"></a> [ha\_port](#input\_ha\_port) | The map key of network\_ports that is to be used for HA | `string` | `"port3"` | no |
| <a name="input_image_location"></a> [image\_location](#input\_image\_location) | Regions where source image is stored in the image project | `string` | `"global"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name of Image to use | `string` | `"fortinet-fgtondemand-741-20230905-001-w-license"` | no |
| <a name="input_image_project"></a> [image\_project](#input\_image\_project) | Project where source image is located | `string` | `"fortigcp-project-001"` | no |
| <a name="input_internal_port"></a> [internal\_port](#input\_internal\_port) | The map key of network\_ports that is to be used for trusted internal network | `string` | `"port2"` | no |
| <a name="input_lb_probe_port"></a> [lb\_probe\_port](#input\_lb\_probe\_port) | probe service port used by loadbalancing health check | `string` | `"8008"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Order(License) type: PAYG = Pay As You Go, BYOL = Bring You Own License | `string` | `"PAYG"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location for naming | `string` | `"northamerica-northeast1"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Instance size | `string` | `"n2-standard-4"` | no |
| <a name="input_mgmt_port"></a> [mgmt\_port](#input\_mgmt\_port) | The map key of network\_ports that is to be used for device management | `string` | `"port4"` | no |
| <a name="input_network_ports"></a> [network\_ports](#input\_network\_ports) | Configuration for ports on the fortigate devices, valid functions are currently public(untrusted), ha, management and internal(trusted) | <pre>map(object({<br>    port_name  = string<br>    project    = string<br>    subnetwork = string<br>  }))</pre> | n/a | yes |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | Network tags to add to instance | `list(any)` | `[]` | no |
| <a name="input_nictype"></a> [nictype](#input\_nictype) | n/a | `string` | `"GVNIC"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Division or group responsible for security and financial commitment. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project to place the Fortigates in | `any` | n/a | yes |
| <a name="input_public_port"></a> [public\_port](#input\_public\_port) | The map key of network\_ports that is to be used for the untrusted public network | `string` | `"port1"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region to place firwalls | `string` | `"northamerica-northeast1"` | no |
| <a name="input_sleep_seconds"></a> [sleep\_seconds](#input\_sleep\_seconds) | number of seconds to sleep before attempting to get the API key | `number` | `100` | no |
| <a name="input_user_defined_string"></a> [user\_defined\_string](#input\_user\_defined\_string) | User defined string. | `string` | n/a | yes |
| <a name="input_workload_ip_cidr_range"></a> [workload\_ip\_cidr\_range](#input\_workload\_ip\_cidr\_range) | Workload CIDR allowed to routed from public network via FortiGate firewall. Defaults to 10.0.0.0/8 | `string` | `"10.0.0.0/8"` | no |
| <a name="input_zone_1"></a> [zone\_1](#input\_zone\_1) | Zone index in the given region to place the first Fortigate appliance in | `string` | `"a"` | no |
| <a name="input_zone_2"></a> [zone\_2](#input\_zone\_2) | Zone index in the given region to place the second Fortigate appliance in | `string` | `"b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ilbnh_public_ip"></a> [external\_ilbnh\_public\_ip](#output\_external\_ilbnh\_public\_ip) | The private IP address of the iLBnH for East-West traffic from external subnet. |
| <a name="output_external_nlb_public_ip"></a> [external\_nlb\_public\_ip](#output\_external\_nlb\_public\_ip) | The public IP address of the external NLB for NorthSouth traffic |
| <a name="output_external_route"></a> [external\_route](#output\_external\_route) | The name of the route table associated to external(public) network. |
| <a name="output_fortigate_admin_password"></a> [fortigate\_admin\_password](#output\_fortigate\_admin\_password) | The initial adminstrator login password for Fortigate NGFW VMs |
| <a name="output_fortigate_admin_username"></a> [fortigate\_admin\_username](#output\_fortigate\_admin\_username) | The adminstrator login name for Fortigate NGFW VMs |
| <a name="output_fortigate_ha_active_mgmt_ip"></a> [fortigate\_ha\_active\_mgmt\_ip](#output\_fortigate\_ha\_active\_mgmt\_ip) | The public IP address used for active instance management. |
| <a name="output_fortigate_ha_passive_mgmt_ip"></a> [fortigate\_ha\_passive\_mgmt\_ip](#output\_fortigate\_ha\_passive\_mgmt\_ip) | The public IP address used for passive instance management. |
| <a name="output_internal_ilbnh_public_ip"></a> [internal\_ilbnh\_public\_ip](#output\_internal\_ilbnh\_public\_ip) | The private IP address of the iLBnH for internal East-West traffic. |
| <a name="output_internal_route"></a> [internal\_route](#output\_internal\_route) | The name of the route table associated to internal(private) network. |
| <a name="output_port_to_network_map"></a> [port\_to\_network\_map](#output\_port\_to\_network\_map) | A map that shows which port is connected to which subnet. |
<!-- END_TF_DOCS -->