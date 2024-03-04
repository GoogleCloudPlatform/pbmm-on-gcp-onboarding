#### FortiGate Deployment Tutorial for Google Cloud
# Terraform deployment
## Day 1 - Adding desired functionality

Day1 templates allow you to add and remove functionality from your existing FortiGate cluster. It is, and it should be treated as merely an example of possibilities and is not meant to be a complete production-ready set of modules for your own production deployment.

The example configuration will deploy the following:
1. Inbound inspection module
1. Outbound inspection module
1. VPC Peering to the workload VPCs
1. East-west firewall rule for communication between tier1 and tier2
1. Example workload servers running a proxy and simple web server

## How to deploy
Note: as terraform cannot create the networks and use them as data source in the same plan, we will use targetting to work around this limitation.

1. Initialize terraform by running `terraform init`
1. Create and verify a plan including all the resources by running `terraform plan -out tf.plan`
1. Deploy by running `terraform apply --parallelism=1 tf.plan`
1. Wait about a minute and test connection over http to the IP address visible in the outputs.

## How to clean up
Run `terraform destroy`
