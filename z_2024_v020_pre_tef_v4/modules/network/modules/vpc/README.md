# Terraform Network Module

This submodule is part of the the `terraform-google-network` module. It creates a vpc network and optionally enables it as a Shared VPC host project.

It supports creating:

- A VPC Network
- Optionally enabling the network as a Shared VPC host

## Usage

Basic usage of this submodule is as follows:

```hcl
module "vpc" {
    source  = "terraform-google-modules/network/google//modules/vpc"
    version = "~> 2.0.0"

    project_id   = "<PROJECT ID>"
    network_name = "example-vpc"

    shared_vpc_host = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Copyright 2019 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");  
you may not use this file except in compliance with the License.  
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software  
distributed under the License is distributed on an "AS IS" BASIS,  
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  
See the License for the specific language governing permissions and  
limitations under the License.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| department\_code | Code for department, part of naming module | `string` | n/a | yes |
| description | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| environment | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| location | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| mtu | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically. | `number` | `0` | no |
| network\_name | The name of the network being created | `any` | n/a | yes |
| project\_id | The ID of the project where this VPC will be created | `any` | n/a | yes |
| routing\_mode | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| shared\_vpc\_host | Makes this project a Shared VPC host if 'true' (default 'false') | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| network | The VPC resource being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
