# Fortigate HA Cluster

## Design Considerations
There are a few design limitations that led to the current design.

- GCP requires the use of instance groups to be able to use load balancers on
  interfaces other than nic0. Each virtual appliance has unique metadata that is
  used for the startup configuration, so static instances were used to
  accomplish this.

- The On-Demand image requires the appliance be able to access the internet on
  it's default port (nic0). In the example the appliances a GCP Cloud NAT is
  created to provide internet access without giving the instance a public IP

- Currently port1 (used for transit network) is open to management because
  `Identity Aware Proxy (IAP)` requires connecting to `nic0` on the instance.
  This can and should be locked down in the appliance to only allow the IAP IP
  address range on this port

- Multi-nic images in GCP need to have guest OS features enabled for multi-nic.
  https://cloud.google.com/vpc/docs/create-use-multiple-interfaces#i_am_having_connectivity_issues_when_using_a_netmask_that_is_not_32

  There is a Terraform resource that creates the image. Below is the `gcloud` equivalent for reference.

  `gcloud compute images create fortinet-fgtondemand-646-20210531-001-w-license-multi-nic \
     --source-image-project fortigcp-project-001 \
     --source-image fortinet-fgtondemand-646-20210531-001-w-license \
     --guest-os-features MULTI_IP_SUBNET \
     --project my-image-project`

  - The Internal network (port3) is used as the `next hop` address in a route
    that created by this module but is maintained by the Fortigate SDN connector
    which is configured in the `terraform-fortios-configuration` module that
    is to be run after this one has completed.

## GCP Firewall Requirements
- IPProtocol: TCP
  ports:
  - '22'
- IPProtocol: TCP
  ports:
  - '443'
- IPProtocol: TCP
  ports:
  - '80'
- IPProtocol: TCP
  ports:
  - '541'
- IPProtocol: TCP
  ports:
  - '3000'
- IPProtocol: TCP
  ports:
  - '8008'

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.74.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute_address_internal_active_ip"></a> [compute\_address\_internal\_active\_ip](#module\_compute\_address\_internal\_active\_ip) | ../terraform-gc-naming//modules/gcp/compute_address_internal_ip | 2.14.3 |
| <a name="module_compute_address_internal_mirror_port"></a> [compute\_address\_internal\_mirror\_port](#module\_compute\_address\_internal\_mirror\_port) | ../terraform-gc-naming//modules/gcp/compute_address_internal_ip | 2.14.3 |
| <a name="module_compute_address_internal_passive_ip"></a> [compute\_address\_internal\_passive\_ip](#module\_compute\_address\_internal\_passive\_ip) | ../terraform-gc-naming//modules/gcp/compute_address_internal_ip | 2.14.3 |
| <a name="module_fortigate_service_account"></a> [fortigate\_service\_account](#module\_fortigate\_service\_account) | ../terraform-gc-naming//modules/gcp/service_account | 2.14.3 |
| <a name="module_instances"></a> [instances](#module\_instances) | ../terraform-virtual-machine | 1.1.0 |
| <a name="module_mirror_backend_service"></a> [mirror\_backend\_service](#module\_mirror\_backend\_service) | ../terraform-gc-naming//modules/gcp/region_backend_service | 2.14.3 |
| <a name="module_mirror_forwarding_rule"></a> [mirror\_forwarding\_rule](#module\_mirror\_forwarding\_rule) | ../terraform-gc-naming//modules/gcp/forwarding_rule | 2.14.3 |
| <a name="module_probe_response_health_check"></a> [probe\_response\_health\_check](#module\_probe\_response\_health\_check) | ../terraform-gc-naming//modules/gcp/health_check | 2.14.3 |
| <a name="module_virtual_machine_instance_group"></a> [virtual\_machine\_instance\_group](#module\_virtual\_machine\_instance\_group) | ../terraform-gc-naming//modules/gcp/virtual_machine_instance_group | 2.14.3 |
| <a name="module_vm_name"></a> [vm\_name](#module\_vm\_name) | ../terraform-gc-naming//modules/gcp/virtual_machine | 2.6.2 |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.active](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.mirror_lb](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.passive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_forwarding_rule.mirror_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_image.fortios](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_image) | resource |
| [google_compute_instance_group.instance_group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group) | resource |
| [google_compute_packet_mirroring.internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_packet_mirroring) | resource |
| [google_compute_region_backend_service.mirror_backend_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_compute_region_health_check.probe_response](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check) | resource |
| [google_compute_route.internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_project_iam_member.fortigate_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.internal_network_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.fortigate_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [null_resource.setup_api_key](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.setup_replication](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.fgt_ha_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_compute_subnetwork.subnetworks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |
| [local_file.Terraform_RW_User_API_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.metadata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.replication](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ssh_private_key_location"></a> [admin\_ssh\_private\_key\_location](#input\_admin\_ssh\_private\_key\_location) | location of the private key to use for connection to the Fortiage for initial settings | `any` | n/a | yes |
| <a name="input_admin_ssh_public_key"></a> [admin\_ssh\_public\_key](#input\_admin\_ssh\_public\_key) | SSH public Key used to configure the Fortigates initial settings. When creating the variable either locally or in the secret do not include the username at the end of the key, it will be inserted during module execution | `any` | n/a | yes |
| <a name="input_compute_resource_policy"></a> [compute\_resource\_policy](#input\_compute\_resource\_policy) | Policy to attach to the disks in the appliances | `string` | `""` | no |
| <a name="input_compute_resource_policy_non_bootdisk"></a> [compute\_resource\_policy\_non\_bootdisk](#input\_compute\_resource\_policy\_non\_bootdisk) | Policy to attach to the disks in the appliances | `string` | `""` | no |
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | Code for department, part of naming module | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| <a name="input_ha_port"></a> [ha\_port](#input\_ha\_port) | The map key of network\_ports that is to be used for HA | `string` | `"port2"` | no |
| <a name="input_image"></a> [image](#input\_image) | Name of Image to use | `string` | `"fortinet-fgtondemand-646-20210531-001-w-license"` | no |
| <a name="input_image_location"></a> [image\_location](#input\_image\_location) | Project where source image is located | `string` | `"fortigcp-project-001"` | no |
| <a name="input_internal_port"></a> [internal\_port](#input\_internal\_port) | The map key of network\_ports that is to be used for internal network | `string` | `"port3"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location for naming | `string` | `"northamerica-northeast1"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Instance size | `string` | `"n1-standard-4"` | no |
| <a name="input_mgmt_port"></a> [mgmt\_port](#input\_mgmt\_port) | The map key of network\_ports that is to be used for device management | `string` | `"port2"` | no |
| <a name="input_mirror_port"></a> [mirror\_port](#input\_mirror\_port) | The map key of network\_ports that is to be used for mirror network | `string` | `"port4"` | no |
| <a name="input_network_ports"></a> [network\_ports](#input\_network\_ports) | Configuration for ports on the fortigate devices, valid functions are currently transit, ha, manaegment and internal | <pre>map(object({<br>    port_name  = string<br>    project    = string<br>    subnetwork = string<br>  }))</pre> | n/a | yes |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | Network tags to add to instance | `list(any)` | `[]` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Division or group responsible for security and financial commitment. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project to place the Fortigates in | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to place firwalls | `string` | `"northamerica-northeast1"` | no |
| <a name="input_sleep_seconds"></a> [sleep\_seconds](#input\_sleep\_seconds) | number of seconds to sleep before attempting to get the API key | `number` | `100` | no |
| <a name="input_transit_port"></a> [transit\_port](#input\_transit\_port) | The map key of network\_ports that is to be used for the transit network | `string` | `"port1"` | no |
| <a name="input_user_defined_string"></a> [user\_defined\_string](#input\_user\_defined\_string) | User defined string. | `string` | n/a | yes |
| <a name="input_zone_1"></a> [zone\_1](#input\_zone\_1) | Zone to place the first Fortigate appliance in | `string` | `"northamerica-northeast1-a"` | no |
| <a name="input_zone_2"></a> [zone\_2](#input\_zone\_2) | Zone to place the second Fortigate appliance in | `string` | `"northamerica-northeast1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Terraform_RW_User_API_key"></a> [Terraform\_RW\_User\_API\_key](#output\_Terraform\_RW\_User\_API\_key) | n/a |
| <a name="output_fgt_ha_password"></a> [fgt\_ha\_password](#output\_fgt\_ha\_password) | n/a |
| <a name="output_internal_route"></a> [internal\_route](#output\_internal\_route) | n/a |
| <a name="output_mirror_lb_address"></a> [mirror\_lb\_address](#output\_mirror\_lb\_address) | n/a |
| <a name="output_port_to_network_map"></a> [port\_to\_network\_map](#output\_port\_to\_network\_map) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->