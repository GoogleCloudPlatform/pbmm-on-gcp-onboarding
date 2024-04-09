# GCP Host Project, Network and Subnets
This module creates a GCP Host network project, VPC and subnets. Multiple
instances of this module can be used to create separate Host projects and
networks for Production, Non-Production with SCED and Non-SCED in both. 

The sample network configuration below defines a network with a single subnet.
The zones are defined in the firewall module below, not by creating separate
subnets for each zone and restricting the routing between the subnets.
Restricting the traffic flow with firewall rules allows for much simpler IP
address management and much more secure network in general as any traffic that
does not have a rule will be dropped, even within the same subnet.

The module currently only supports the Non-SCED network type as the Interconnect
has not been setup.

As with any network, the subnet ranges must be unique across all routing domains
unless a third party device is used for NAT(not included)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_user\_defined\_string | Additional user defined string. | `string` | `""` | no |
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| billing\_account | billing account ID | `string` | n/a | yes |
| default\_region | Default region to deploy resources to | `string` | `"northamerica-northeast1"` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `true` | no |
| department\_code | Code for department, part of naming module | `string` | n/a | yes |
| description | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| enable\_endpoint\_independent\_mapping | Specifies if endpoint independent mapping is enabled. | `bool` | `null` | no |
| environment | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| icmp\_idle\_timeout\_sec | Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created. | `string` | `"30"` | no |
| location | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| log\_config\_enable | Indicates whether or not to export logs | `bool` | `false` | no |
| log\_config\_filter | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL" | `string` | `"ALL"` | no |
| min\_ports\_per\_vm | Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created. | `string` | `"64"` | no |
| mtu | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically. | `number` | `0` | no |
| nat\_ip\_allocate\_option | Value inferred based on nat\_ips. If present set to MANUAL\_ONLY, otherwise AUTO\_ONLY. | `string` | `"false"` | no |
| nat\_ips | List of self\_links of external IPs. Changing this forces a new NAT to be created. | `list(string)` | `[]` | no |
| nat\_name | Defaults to 'cloud-nat-RANDOM\_SUFFIX'. Changing this forces a new NAT to be created. | `string` | `""` | no |
| nat\_subnetworks | n/a | <pre>list(object({<br>    name                     = string,<br>    source_ip_ranges_to_nat  = list(string)<br>    secondary_ip_range_names = list(string)<br>  }))</pre> | `[]` | no |
| network | VPN name, only if router is not passed in and is created by the module. | `string` | `""` | no |
| network\_name | The name of the network being created | `any` | n/a | yes |
| owner | Division or group responsible for security and financial commitment. | `string` | n/a | yes |
| parent | folder/#### or organizations/#### to place the project into | `string` | n/a | yes |
| region | Region for nat gw | `string` | `"northamerica-northeast1"` | no |
| router\_asn | Router ASN, only if router is not passed in and is created by the module. | `string` | `"64514"` | no |
| router\_name | The name of the router in which this NAT will be configured. Changing this forces a new NAT to be created. | `any` | n/a | yes |
| routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| routing\_mode | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| services | List of services to enable on the bootstrap project required for using their APIs | `list(string)` | n/a | yes |
| source\_subnetwork\_ip\_ranges\_to\_nat | Defaults to ALL\_SUBNETWORKS\_ALL\_IP\_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, LIST\_OF\_SUBNETWORKS. Changing this forces a new NAT to be created. | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| subnets | The list of subnets being created | `list(map(string))` | n/a | yes |
| tcp\_established\_idle\_timeout\_sec | Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created. | `string` | `"1200"` | no |
| tcp\_transitory\_idle\_timeout\_sec | Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created. | `string` | `"30"` | no |
| udp\_idle\_timeout\_sec | Timeout (in seconds) for UDP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created. | `string` | `"30"` | no |
| user\_defined\_string | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_nat | Name of the Cloud NAT |
| nat\_ip\_allocate\_option | NAT IP allocation mode |
| nat\_router | Cloud NAT router |
| network | The VPC resource being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | ID of host project |
| routes | The created routes resources |
| subnets | The created subnet resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->