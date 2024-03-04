#### FortiGate Deployment Tutorial for Google Cloud
# Terraform deployment

This repo contains terraform modules to deploy and manage FortiGate reference architecture in Google Cloud. It uses both Google Cloud as well as FortiOS providers to demonstrate high agility of managing FortiGate appliances together with cloud using IaC approach.

![Reference architecture overview](../docs/images/overview.svg)

The templates are split into [day0](day0/) and [day1](day1/) folders, which should be deployed as separate configurations.

* [Day0](day0) - deploys a cluster of FortiGates into GCP and connects them to 4 subnets. The subnets might be created before and their **names** be provided to the fgcp-ha-ap-lb module in `subnets` variable, or the VPCs and subnets can be created using sample-networks module as demonstrated in the code. Day0 "base" deployment does not offer any network functionality and is simply a foundation required by all Day1 modules.

* [Day1](day1) - uses a set of modules to add functionalities related to specific use-cases on top of the base day0 setup. You MUST first deploy day0 before attempting to deploy day1. You also MUST adapt [day0-import.tf](day1/day0-import.tf) template file to point to your state file for day0 configuration if not using the default local backend. Usecase modules use both Google Cloud as well as FortiOS terraform providers to offer complete configuration support of both cloud and the FortiGate instances. FortiOS api-key is imported from the day0 state file.


## Supported use-cases
### Protecting public services (ingress N-S inspection)
[modules/usecases/inbound-ns](modules/usecases/inbound-ns)

FortiGate instances empowered by FortiGuard services can be used to secure your workloads running in the cloud against any bad actors accessing them from the Internet. Publishing your services via FortiGate allows you to not only scan traffic against malicious payload, but also provide granular access rules or enforce ZTNA policies.

To publish a service via FortiGate the following changes are performed:
- create new public IP address and external network load balancer in GCP
- add a VIP and firewall policy in FortiGate

Although the workloads could be deployed directly into trusted VPC, they are usually placed in separate VPC (often in a different project), which is peered with trusted. See [spoke-vpc](modules/usecases/spoke-vpc) for more details.

For the return traffic, the module leverages default custom route which is part of the base module.

### Secure NAT Gateway (outbound N-S inspection)
[modules/usecases/outbound-ns](modules/usecases/outbound-ns)

FortiGate is a great choice to replace the Cloud NAT service. You can easily regulate access based on VM metadata and grant very selective access to internet services while adding AV scanning on top to make sure your workloads remain healthy.

To enable Internet access the following changes are added:
- FortiGate IP Pool object and an outbound firewall policy

This module currently leverages the ELB created by inbound-ns.

### Segmentation for multi-tier infrastructure (E-W inspection)

East-west inspection in GCP can be provided only for traffic between VPC Networks (not inside a network), thus each security zone needs to be created as a separate VPC. Traffic between all workload VPCs properly peered to the FortiGate trusted VPC will be inspected by FortiGate VMs.

To enable east-west scanning use the [spoke-vpc](modules/usecases/spoke-vpc) module for creating peerings.

Note: due to GCP limitations on parallel peering operations you might encounter errors when deploying this module as for the clarity of code it limits explicit depends_on arguments. If you encounter any errors just try again.

## Next steps:
- [Deploy base configuration (day0)](day0)
