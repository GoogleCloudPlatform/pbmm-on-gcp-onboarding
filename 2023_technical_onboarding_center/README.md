# Landing Zone Instructions

## Clone the repo
```
gcloud config set project lz-tls
root_@cloudshell:~ (lz-tls)$ cd lz-tls
root_@cloudshell:~/lz-tls (lz-tls)$ ls
_lz2  pbmm-on-gcp-onboarding  _test_pull
root_@cloudshell:~/lz-tls (lz-tls)$ mkdir _interconnect
root_@cloudshell:~/lz-tls (lz-tls)$ cd _interconnect/
root_@cloudshell:~/lz-tls/_interconnect (lz-tls)$ git clone  https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding.git
Cloning into 'pbmm-on-gcp-onboarding'...
remote: Enumerating objects: 4596, done.
remote: Counting objects: 100% (1681/1681), done.
remote: Compressing objects: 100% (519/519), done.
remote: Total 4596 (delta 1208), reused 1528 (delta 1133), pack-reused 2915
Receiving objects: 100% (4596/4596), 26.48 MiB | 23.08 MiB/s, done.
Resolving deltas: 100% (2920/2920), done.
root_@cloudshell:~/lz-tls/_interconnect (lz-tls)$ cd ..
```

## Move this folder over to your own landing zone repo

```
  where csr is the original lz and we just cloned the pbmm repo into a new pbmm.. folder

root_@cloudshell:~/lz-tls (lz-tls)$ cp -rp _interconnect/pbmm-on-gcp-onboarding/2023_technical_onboarding_center/20-partner-interconnect/ pbmm-on-gcp-onboarding/environments/nonprod/
root_@cloudshell:~/lz-tls (lz-tls)$ cd pbmm-on-gcp-onboarding/environments/nonprod/
```

## Set variables
Navigate to the 20-partner-interconnect folder

```

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
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        ../../20230129_2030_partial_1010.txt
        20-partner-interconnect/

nothing added to commit but untracked files present (use "git add" to track)
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git add 20-partner-interconnect/

root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git add 20-partner-interconnect/
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git commit -m "add partner interconnect"
[main 55526c6] add partner interconnect
 4 files changed, 160 insertions(+)
 create mode 100644 environments/nonprod/20-partner-interconnect/main.tf
 create mode 100644 environments/nonprod/20-partner-interconnect/outputs.tf
 create mode 100644 environments/nonprod/20-partner-interconnect/settings.tfvars
 create mode 100644 environments/nonprod/20-partner-interconnect/variables.tf
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git push origin csr
error: src refspec csr does not match any
error: failed to push some refs to 'origin'
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/nonprod (lz-tls)$ git push csr main
Enumerating objects: 12, done.
Counting objects: 100% (12/12), done.
Delta compression using up to 4 threads
Compressing objects: 100% (9/9), done.
Writing objects: 100% (9/9), 2.83 KiB | 1.41 MiB/s, done.
Total 9 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3)
To https://source.developers.google.com/p/tspe-tls-tls-dv/r/tlscsr
   e1ed801..55526c6  main -> main
   
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
