#### FortiGate Deployment Tutorial for Google Cloud: Use-cases
# Protecting public services (ingress N-S inspection)

FortiGate instances empowered by FortiGuard services can be used to secure your workloads running in the cloud against any bad actors accessing them from the Internet. Publishing your services via FortiGate allows you to not only scan traffic against malicious payload, but also provide granular access rules or enforce ZTNA policies.

To publish a service via FortiGate the following changes are performed:
- create new public IP address and external network load balancer in GCP
- add a VIP and firewall policy in FortiGate

For the return traffic, the module leverages default custom route which is part of the base module.

## Design
![Inbound traffic flow - overview](https://lucid.app/publicSegments/view/320011a7-3790-4b2e-825e-6c5f7101af0b/image.png)

1. User initiates connection to an external IP assigned as ELB frontend
2. External Load Balancer forwards connection to identified active FortiGate instance
3. FortiGate uses Virtual IP and Firewal Policy to DNAT connection and send it to the desired target

## How to use this module
Use terraform `module` block to deploy a single external IP address and related resources.

To configure this module you have to provide the following arguments:
- `srv_name` - is simply a label which will be used to create names of resources in cloud and in FortiGate
- `day0` - map of day0 remote state outputs. You'll have to create a data.terraform_remote_state object and pass its outputs to this argument
- `targets` - list of `{ip, port}` maps listing ports and target IP addresses for forwarded connections

See [day1](../../../day1/) for example use:

```
module "inbound" {
  source = "../modules/usecases/inbound-ns"

  day0 = data.terraform_remote_state.base.outputs
  srv_name = "my-service"
  targets = [{
    ip = "10.0.0.10",
    port = 80
  }]
}
```
