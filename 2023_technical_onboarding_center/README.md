# Landing Zone Instructions

# Prerequisites
- Shared VPC
- admin IAM roles
- 

## Change to GCP project hosting the shared VPC
```
gcloud config set project lz-tls
```
## Clone the repo
```
cd lz-tls
mkdir _interconnect
cd _interconnect/
git clone  https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding.git
root_@cloudshell:~/lz-tls/_interconnect (lz-tls)$ cd ..
```

## Move this folder over to your own landing zone repo

```
  where csr is the original lz and we just cloned the pbmm repo into a new pbmm.. folder

cp -rp _interconnect/pbmm-on-gcp-onboarding/2023_technical_onboarding_center/20-partner-interconnect/ pbmm-on-gcp-onboarding/environments/nonprod/
cd pbmm-on-gcp-onboarding/environments/nonprod/
```

## Set variables
Navigate to the 20-partner-interconnect folder and edit settings.tfvars if required below 

```
vpc_name = "vpc-nonprod-shared"
region1 = "northamerica-northeast1"
```

edit settings.tfvars

## Manual Terraform CLI Option - for those not running CSR
This option can be run as well - out of band - on the existing CSR repo for testing purposes.  However I recommend you move this folder into your current landing zone folder and add/merge the changes into your local CSR repo and let Cloud Build kick in via its triggers.

### Init
```
terraform init
```

### Plan
```
terraform plan --var-file settings.tfvars
```

### Apply

``
terraform apply --var-file settings.tfvars
``


## Automated GitOps via CSR - default Landing Zone option
Move this folder into your current landing zone folder and add/merge the changes into your local CSR repo and let Cloud Build kick in via its triggers.

```
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git status
On branch main
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git add 20-partner-interconnect/

root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git add 20-partner-interconnect/
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git commit -m "add partner interconnect"
[main 55526c6] add partner interconnect
 4 files changed, 160 insertions(+)
 create mode 100644 environments/nonprod/20-partner-interconnect/main.tf
 create mode 100644 environments/nonprod/20-partner-interconnect/outputs.tf
 create mode 100644 environments/nonprod/20-partner-interconnect/settings.tfvars
 create mode 100644 environments/nonprod/20-partner-interconnect/variables.tf
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git push csr main
Total 9 (delta 3), reused 0 (delta 0), pack-reused 0
To https://source.developers.google.com/p/tspe-tls-tls-dv/r/tlscsr
  
```
Let Cloud Build kick in on the non-prod trigger

## Examine Output

```
google_compute_interconnect_attachment.on_prem1: Creation complete after 12s [id=projects/vpc-host-nonprod-hh015-gz357/regions/northamerica-northeast2/interconnectAttachments/on-prem-attachment1]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

on_prem1 = {
  "admin_enabled" = true
  "bandwidth" = ""
  "candidate_subnets" = tolist(null) /* of string */
  "cloud_router_ip_address" = ""
  "creation_timestamp" = "2023-07-11T10:52:41.638-07:00"
  "customer_router_ip_address" = ""
  "description" = ""
  "edge_availability_domain" = "AVAILABILITY_DOMAIN_1"
  "encryption" = "NONE"
  "google_reference_id" = ""
  "id" = "projects/vpc-host-nonprod-hh...57/regions/northamerica-northeast2/interconnectAttachments/on-prem-attachment1"
  "interconnect" = ""
  "ipsec_internal_addresses" = tolist(null) /* of string */
  "mtu" = "1500"
  "name" = "on-prem-attachment1"
  "pairing_key" = "93061e7...8a41/northamerica-northeast2/1"
  "partner_asn" = ""
  "private_interconnect_info" = tolist([])
  "project" = "vpc-host-nonprod-hh015-gz357"
  "region" = "https://www.googleapis.com/compute/v1/projects/vpc-host-nonprod-hh015-gz357/regions/northamerica-northeast2"
  "router" = "https://www.googleapis.com/compute/v1/projects/vpc-host-nonprod-hh015-gz357/regions/northamerica-northeast2/routers/router-1"
  "self_link" = "https://www.googleapis.com/compute/v1/projects/vpc-host-nonprod-hh015-gz357/regions/northamerica-northeast2/interconnectAttachments/on-prem-attachment1"
  "state" = "PENDING_PARTNER"
  "timeouts" = null /* object */
  "type" = "PARTNER"
  "vlan_tag8021q" = 0
}
```
## Destroy

```
terraform destroy --var-file settings.tfvars
```

# Links
- https://cloud.google.com/network-connectivity/docs/interconnect/how-to/partner/provisioning-overview
- https://cloud.google.com/network-connectivity/docs/interconnect/concepts/best-practices
- https://cloud.google.com/vpc/docs/shared-vpc
