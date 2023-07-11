# Landing Zone Instructions

## Set variables
Navigate to the 20-partner-interconnect folder

edit settings.tfvars

## Init
```
terraform init
```

## Plan
```
terraform plan --var-file settings.tfvars
```

## Apply

``
terraform apply --var-file settings.tfvars
``

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
