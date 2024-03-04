#### FortiGate Deployment Tutorial for Google Cloud
# Terraform deployment
## Base module (day0)

This configuration deploys a cluster of FortiGates into GCP and connects them to 4 subnets. The subnets might be created before and their **names** be provided to the fgcp-ha-ap-lb module in `subnets` variable, or the VPCs and subnets can be created as part of this configuration (eg. using sample-networks module). Day0 "base" deployment does not offer any network functionality and is simply a foundation required by all Day1 modules.

The design is using a "load balancer sandwich" design with ILBs (Internal Load Balancers) used as custom route next-hop for detecting currently active instance and routing traffic through it. Using load balancers guarantees fast failover time (~10 secs.) and stateful failover (currently in preview). Base configuration includes the ILB on trusted side of the cluster as it will be necessary for all use-cases (except for NCC integration).

More details on the design can be found [here](../../docs/architecture-reference.md).

### Prerequisites
#### Enable APIs
Enable compute and container APIs. While this tutorial does not use containers, the API is referenced when creating the custom role:
```
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
```
Compute Engine API must be enabled for this tutorial, Kubernetes Engine API (container.googleapis.com) can be omitted, but it will trigger warnings when creating a custom role and when debugging SDN Connector on FortiGate CLI.

#### Service account
FortiGate uses its External Fabric Connector (a.k.a. SDN Connector) to support firewall policies based on GCE metadata instead of just IP addresses. In order for Connector to function, the FortiGate instances must be given access to all needed projects. It is highly recommended to use the minimum set of privileges by creating a custom role and a service account using `[service_account_create.sh]`(../../service_account_create.sh) script and providing service account name in `service_account` module variable. Otherwise the default GCE account will be used.

#### Licenses
This tutorial uses BYOL-licensed images. You must obtain and activate your licenses before running terraform configuration. The `.lic` files must be downloaded from [support.fortinet.com](https://support.fortinet.com) portal and put in the day0 directory as `lic1.lic` and `lic2.lic`. If you prefer to use the PAYG images you'll have to:

1. remove the reference to the files from the [day0/main.tf](main.tf) file (lines 31-34)
1. modify the image used by the module by replacing `family = "fortigate-70-byol"` with `family = "fortigate-70-payg"` in the [modules/fgcp-ha-ap-lb](../modules/fgcp-ha-ap-lb) file

#### Networks
The `fgcp-ha-ap-lb` module takes a list of subnet names as its `subnets` argument. 4 VPC networks and subnets will be created in the region where you plan to deploy FortiGates as a part of day0 configuration, so they do not need to be created manually before applying the configuration.  The  VPCs will be connected to 4 different network interfaces of your FortiGate instances:
- port1 (nic0) - external (untrusted) network
- port2 (nic1) - internal (trusted) network
- port3 (nic2) - FGCP hertbeat/sync interface
- port4 (nic3) - dedicated management interface

Make sure your project quota is high enough to accommodate for the new VPC networks.

*Note: due to the way Google Cloud networking works it is NOT possible to deploy a FortiGate VM instance with NICs connected to different subnets of the same VPC.*

### Resources
Following resources will be created:
- FortiGate VM instances
- zonal unmanaged instance groups
- backend service
- internal load balancer
- external IP addresses to be used for management
- multiple reserved internal addresses

## How to deploy
1. (optionally) run [service_account_create.sh](../../service_account_create.sh) to create new service account and IAM role
1. If you want to use existing subnets:
    1. edit main.tf to point to them in `subnets` argument of `fortigates` module AND
    1. comment reference to `sample_networks` module as well as explicit dependency to it in `main.tf`
1. Add your FortiGate license files (*.lic) to the day0 directory and update file names in `license_files` argument for `fortigate` module in `main.tf` file
1. Edit `terraform.tfvars` to indicate your `GCP_PROJECT` and `GCE_REGION`
1. Add your desired resource name prefix to `terraform.tfvars` as `prefix` variable (defaults to "fgt-")
1. make sure you are logged into GCP by running `gcloud auth list`
1. run `terraform init`
1. run `terraform plan -out day0.plan` and review the list of resources to be created
1. run `terraform apply day0.plan` to create resources
1. Proceed to [day1](../day1) for the next steps

After everything is deployed you can connect to the management NIC of primary FortiGate using SSH or HTTPS (on standard ports) via the first IP address printed in `fgt-mgmt-eips`. Log in as **admin**, the initial password is set to primary instance id (for convenience visible as `default_password` output). You can verify the FortiGates are both up and running, licensed and clustered by running `get sys ha status` in FortiGate CLI.

## How to clean up
1. Make sure you do not have any day1 configuration deployed, eg. by going to day1 directory and running `terraform show` (you should see empty output)
1. in day0 directory run `terraform destroy` and confirm
