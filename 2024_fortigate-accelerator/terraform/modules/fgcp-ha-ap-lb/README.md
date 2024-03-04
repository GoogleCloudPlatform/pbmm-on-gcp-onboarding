# FortiGate reference architecture for GCP
## Base module

This terraform module deploys the base part of FortiGate reference architecture consisting of:
- 2 FortiGate VM instances - preconfigured in FGCP Active-Passive cluster
- zonal instance groups to be used later as components of backend services
- internal load balancer resources in trusted (internal) network
- cloud firewall rules opening ALL communication on untrusted and trusted networks
- cloud firewall rules allowing cluster sync and administrative access
- static external IP addresses for management bound to nic3 (port4) of FortiGates

Base module does NOT provide any networking functionality, use day1 (usecase) modules to enable individual use-cases for your deployment. See documentation in parent directory for list of currently supported use-cases with terraform modules.

### Customizations
1. modify google_compute_image.fgt_image in main.tf to use any other version than newest 7.0 BYOL
1. add your configuration to fgt-base-config.tpl to have it applied during provisioning
1. modify google_compute_disk.logdisk in main.tf to change logdisk parameters (by default 30GB pd-ssd)
1. all addresses are static but picked automatically from the pool of available addresses for a given subnet. modify addresses.tf to manually indicated addresses you want to assign.

### How to use this module
To use this module include it in your root configuration and provide with at least the following arguments:
- region - name of the region to deploy to (zones will be selected automatically)
- license_files - list of paths to 2 license (.lic) files to be applied to the FortiGates. If skipped, VMs will be deployed without license and you will have to apply them manually upon first connection.
- subnets - list of 4 names of subnets already existing in the region to be used as external, internal, heartbeat and management networks.

See [main.tf in day0](../../day0/main.tf) directory for an example.
