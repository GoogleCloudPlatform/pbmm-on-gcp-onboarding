# GCE Virtual Machine

Create a Linux or Windows VM on GCE with the option to add disks and snapshot policies

Include this module in your workspace by adding a module block as shown in the example below. See the Inputs tab for all variables that can be set.

```hcl

# Module must be repeated for each VM you wish to create. Terraform 0.13 will add `count` and `for_each` to the module resource.
module "VM1" {
  source  = "./modules/virtual-machine"
  version = "v0.1.3" # change version to the last one

  vm_name     = "foo"
  vm_env      = "bar"
  vm_zone     = "northamerica-northeast1-a"
  image       = "rhel-latest"
  subnet_name = "snet-bfpte-app-nane"

  label_environment     = "test"
  label_owner           = "test"
  label_snow_queue = "test"
  label_application     = "test"

  service_account_email_address = "<my-service-account>@<my-project>.iam.gserviceaccount.com"

  # disks is optional and can have many maps in the list, a disk will be created for each map and attached to the VM
  disks = [
    {
      id   = "app-disk"
      size = 20
      type = "pd-ssd"
    },
    {
      id   = "1"
      size = 90
      type = "pd-ssd"
    }
  ]
}
```

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
| <a name="module_boot_disk_name"></a> [boot\_disk\_name](#module\_boot\_disk\_name) | ../terraform-gc-naming//modules/gcp/managed_disk_os | 2.6.2 |
| <a name="module_data_disk_name"></a> [data\_disk\_name](#module\_data\_disk\_name) | ../terraform-gc-naming//modules/gcp/managed_disk_data | 2.6.2 |
| <a name="module_vm_name"></a> [vm\_name](#module\_vm\_name) | ../terraform-gc-naming//modules/gcp/virtual_machine | 2.6.2 |

## Resources

| Name | Type |
|------|------|
| [google_compute_disk.vm_disk](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk) | resource |
| [google_compute_disk_resource_policy_attachment.additional_disk_attachment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk_resource_policy_attachment) | resource |
| [google_compute_disk_resource_policy_attachment.os_disk_attachment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk_resource_policy_attachment) | resource |
| [google_compute_instance.virtual_machine](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_boot_disk_size"></a> [boot\_disk\_size](#input\_boot\_disk\_size) | Size of boot/root disk | `string` | `"20"` | no |
| <a name="input_boot_disk_type"></a> [boot\_disk\_type](#input\_boot\_disk\_type) | Disk type, valid options are [pd-ssd,pd-standard] | `string` | `"pd-standard"` | no |
| <a name="input_can_ip_forward"></a> [can\_ip\_forward](#input\_can\_ip\_forward) | Ability to act as a router on the network | `bool` | `false` | no |
| <a name="input_compute_resource_policy"></a> [compute\_resource\_policy](#input\_compute\_resource\_policy) | Disk snapshot policy, if left as none, no policy will be applied | `string` | `""` | no |
| <a name="input_compute_resource_policy_non_bootdisk"></a> [compute\_resource\_policy\_non\_bootdisk](#input\_compute\_resource\_policy\_non\_bootdisk) | Disk snapshot policy, if left as none, no policy will be applied | `string` | `""` | no |
| <a name="input_department_code"></a> [department\_code](#input\_department\_code) | Code for department, part of naming module | `string` | n/a | yes |
| <a name="input_device_type"></a> [device\_type](#input\_device\_type) | Device type for naming purposes | `string` | n/a | yes |
| <a name="input_disks"></a> [disks](#input\_disks) | Disks map for extra disks | <pre>list(object({<br>    id   = string<br>    type = string<br>    size = number<br>  }))</pre> | `[]` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | domain used in vm hostname | `string` | `"c3.ssc-spc.cloud-nuage.canada.ca"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | Image name | `string` | `"rhel-latest"` | no |
| <a name="input_image_location"></a> [image\_location](#input\_image\_location) | Instance source image project | `any` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to place on the VM | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | VM size | `string` | `"n1-standard-2"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | custom\_metadata to add to the instance | `map(string)` | `{}` | no |
| <a name="input_metadata_startup_script"></a> [metadata\_startup\_script](#input\_metadata\_startup\_script) | startup script for vm | `string` | `null` | no |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | Map of objects containing network interfaces. id sets the order of the attachement to the VM | <pre>list(object({<br>    id                 = string # sets the order of the attachement to the VM<br>    subnetwork         = string<br>    subnetwork_project = string<br>    network_ip         = optional(string)<br>    access_config = optional(list(object({<br>      nat_ip = string<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | Network tags for firewall rules | `list` | `[]` | no |
| <a name="input_number_suffix"></a> [number\_suffix](#input\_number\_suffix) | Number suffix for the resource name. | `string` | `"01"` | no |
| <a name="input_project"></a> [project](#input\_project) | name of project | `string` | n/a | yes |
| <a name="input_service_account_email_address"></a> [service\_account\_email\_address](#input\_service\_account\_email\_address) | Service account to run the VM | `any` | n/a | yes |
| <a name="input_service_account_scopes"></a> [service\_account\_scopes](#input\_service\_account\_scopes) | GCE scopes which VM should be able to access and/or change | `list` | `[]` | no |
| <a name="input_user_defined_string"></a> [user\_defined\_string](#input\_user\_defined\_string) | User defined string. | `string` | n/a | yes |
| <a name="input_vm_zone"></a> [vm\_zone](#input\_vm\_zone) | GCE zone to deploy VM | `string` | `"northamerica-northeast1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_can_ip_forward"></a> [can\_ip\_forward](#output\_can\_ip\_forward) | n/a |
| <a name="output_domain"></a> [domain](#output\_domain) | Output of domain for test cases |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | IP Addresses |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
| <a name="output_zone"></a> [zone](#output\_zone) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->