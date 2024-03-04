#### FortiGate Deployment Tutorial for Google Cloud: Use-cases
# Secure NAT Gateway (outbound N-S inspection)

FortiGate is a great choice to replace the Cloud NAT service. You can easily police access based on VM metadata and grant very selective access to internet services while adding AV scanning on top to make sure your workloads remain healthy.

To enable Internet access the following changes are added:
- FortiGate IP Pool object and an outbound firewall policy

This module currently leverages the ELB created by inbound-ns.

## Design
![Outbound N-S flow overview](https://lucid.app/publicSegments/view/72df2b47-4ff6-4f48-867e-742684dce6aa/image.png)

1. Workload initiates connection towards Internet
2. Connection matches custom route imported from FortiGate trusted VPC and is forwarded over VPC peering
3. Internal Load Balancer selects currently active FortiGate appliance and forwards traffic to it
4. FortiGate performs Source NAT to ELB external IP and passes the connection.

## How to use this module
Note: **Currently `outbound-ns` requires that you first deploy `inbound-ns`.**

Use terraform `module` block to add outbound connectivity objects to FortiGate.

To configure this module you have to provide the following arguments:
- `name` - is simply a label which will be used to create names of resources
- `day0` - map of day0 remote state outputs. You'll have to create a data.terraform_remote_state object and pass its outputs to this argument
- `elb` - self link of forwarding rule to be used for SNAT

Additional FortiGate-specific arguments can be added to fine-tune settings of the firewall policy.

See [day1](../../../day1/) for example use:
```
module "outbound" {
  source = "../modules/usecases/outbound-ns"

  day0 = data.terraform_remote_state.base.outputs
  elb = module.inbound.elb_frule
}
```
