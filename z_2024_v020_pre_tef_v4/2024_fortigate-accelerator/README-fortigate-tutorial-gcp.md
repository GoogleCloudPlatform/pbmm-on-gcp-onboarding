# FortiGate Deployment Tutorial for Google Cloud

This repository contains documentation and code to use for a sample deployment of a FortiGate reference architecture in Google Cloud.

Reference architecture describes the recommended way to configure FortiGate VM instances and Google Cloud infrastructure. It is designed to cover most of the use-cases and will meet the requirements of most of the deployments. Note though, that in some cases a different architecture or some modifications might be required. If in doubt - please contact Fortinet cloud team for assistance at gcptech (at) fortinet.com

The code samples will deploy FortiGate HA cluster and a simple 2-tier web application. FortiGates will protect the sample app by inspecting inbound north-south traffic from Internet, outbound south-north traffic from servers to Internet as well as East-West traffic between web application Tier 1 and Tier 2.

This repository is use-case centric. It was created to help you match the configuration to the security functions you will use. Where possible, the use-cases are separated from the base FortiGate deployment. As different tools have different capabilities, this separation is implemented differently depending on the tool of your choice:
- *Deployment Manager* - although Deployment Manager supports adding custom APIs, it is not a commonly used feature. DM templates in this repo deploy all functionality as part of Day 0 bootstrapping. Updating the DM deployment will NOT result in any changes to the FortiGate configuration.
- *Terraform* - FortiOS provider allows creating, changing and destroying of FortiGate configuration "resources". You will find that all functionality is added after the deployment of the FortiGate instances as "Day 1" operations and can be changed/destroyed by applying a modified day1 configuration. This method provides maximum flexibility for Day n operations, but many FortiGate administrators decide to use tools different than Terraform for any configuration after deployment.
- *gcloud* - deployment using Google Cloud CLI is provided as a large script. Parts of FortiGate configuration related to use-cases is added after the base deployment using SSH. Removing or changing of configuration is not part of the provided example script, but can be easily scripted by administrators.

## Architecture
The recommended way to deploy FortiGates is a multi-AZ Active-Passive FGCP cluster with set of (up to 3) load balancers to direct the traffic flows through the active FGT instance (a pattern known as "load balancer sandwich"):
![FortiGate reference architecture overview](docs/images/overview.svg)

While it is technically possible to use a single network interface to connect to both internal and external networks, it is recommended to use one external and one internal NIC for clarity of architecture and FortiGate configuration. Additional two NICs will be used for cluster heartbeat and management. This means you will need 4 separate VPC networks to connect to the FortiGates.

*Note: starting from version 7.0 you can use the same network interface for FGCP heartbeat and management.*

It is recommended to place the workloads (your application servers) in separate VPCs (possibly in separate projects) and use [VPC Peering](https://cloud.google.com/vpc/docs/vpc-peering) to maintain connectivity between FortiGate internal VPC and workload VPCs. You can choose to either:

- follow a classic multi-tier deployment pattern - to provide East-West inspection between tiers, each one of them needs to be deployed as a separate VPC (mind the peering group limits)
- follow the standard GCP model and use only 3 large Shared VPCs (prod, non-prod, dev) peered with the internal VPC of FortiGate. Note that this design does **NOT** allow East-West threat inspection within Shared VPCs.

* [Read more about the reference architecture design in GCP](docs/architecture-reference.md)
* [Read more about the tutorial sample architecture](docs/architecture-tutorial.md)

## How To Deploy

* [Creating a custom role and service account for FortiGates](docs/sdn_privileges.md)
* [Deploy using Terraform](terraform/)
* [Deploy using Deployment Manager](deployment-manager/)
* [Deploy using Google Cloud CLI](gcloud/)
