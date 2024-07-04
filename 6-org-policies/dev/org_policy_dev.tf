
locals {
  list_prj_dev_shared_network_exclude = [
    local.prj_d_shared_base,
    local.prj_d_shared_restricted,
    local.base_net_hub_project_id,
    local.restricted_net_hub_project_id,
  ]

  list_fldr_dev_policy_exclude = [
    local.fldr_development,
  ]

  boolean_type_organization_policies = toset([
    "compute.disableNestedVirtualization",
    "compute.disableSerialPortAccess",
    "compute.restrictXpnProjectLienRemoval",
    "compute.setNewProjectDefaultToZonalDNSOnly",
    "compute.requireOsLogin",
    "sql.restrictPublicIp",
    "sql.restrictAuthorizedNetworks",
    "iam.disableServiceAccountKeyCreation",
    "iam.automaticIamGrantsForDefaultServiceAccounts",
    "iam.disableServiceAccountKeyUpload",
    "storage.uniformBucketLevelAccess",
    "storage.publicAccessPrevention"
  ])

  # list_prj_org_policy_requireShieldedVm_enforce = [
  #   local.prj_d_shared_base,
  #   local.prj_d_shared_restricted,
  #   local.base_net_hub_project_id,
  #   local.restricted_net_hub_project_id,
  # ]

  # list_prj_org_policy_disableSerialPortAccess_exclude = [
  #   local.prj_d_shared_base,
  #   local.prj_d_shared_restricted,
  #   local.base_net_hub_project_id,
  #   local.restricted_net_hub_project_id,
  # ]

  # list_fldr_org_policy_disableSerialPortAccess_exclude = [
  #   local.fldr_development,
  # ]

  # list_prj_org_policy_disableVpcExternalIpv6_exclude = [
  #   local.prj_d_shared_base,
  #   local.prj_d_shared_restricted,
  #   local.base_net_hub_project_id,
  #   local.restricted_net_hub_project_id,
  # ]

  # list_fldr_org_policy_disableVpcExternalIpv6_exclude = [
  #   local.fldr_development,
  # ]
}

module "organization_policies_type_boolean_fldr_override" {
  source   = "terraform-google-modules/org-policy/google"
  version  = "~> 5.1"
  for_each = local.boolean_type_organization_policies

  folder_id   = local.fldr_development
  policy_for  = "folder"
  policy_type = "boolean"
  enforce     = false
  constraint  = "constraints/${each.value}"
}

module "organization_policies_type_boolean_prj_d_shared_base_override" {
  source   = "terraform-google-modules/org-policy/google"
  version  = "~> 5.1"
  for_each = local.boolean_type_organization_policies

  project_id   = local.prj_d_shared_base
  policy_for  = "project"
  policy_type = "boolean"
  enforce     = false
  constraint  = "constraints/${each.value}"
}

module "organization_policies_type_boolean_prj_d_shared_restricted_override" {
  source   = "terraform-google-modules/org-policy/google"
  version  = "~> 5.1"
  for_each = local.boolean_type_organization_policies

  project_id   = local.prj_d_shared_restricted
  policy_for  = "project"
  policy_type = "boolean"
  enforce     = false
  constraint  = "constraints/${each.value}"
}

module "org_policy_dev_shared_disableSerialPortAccess_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_prj_dev_shared_network_exclude)
  constraint  = "constraints/compute.disableSerialPortAccess"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce     = false
}

module "org_policy_disableSerialPortAccess_fldr_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_fldr_dev_policy_exclude)
  constraint  = "constraints/compute.disableSerialPortAccess"
  policy_for  = "folder"
  policy_type = "boolean"
  folder_id   = each.value
  enforce     = false
}

module "org_policy_disableVpcExternalIpv6_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_prj_dev_shared_network_exclude)
  constraint  = "constraints/compute.disableVpcExternalIpv6"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce     = false
}

module "org_policy_disableVpcExternalIpv6_fldr_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_fldr_dev_policy_exclude)
  constraint  = "constraints/compute.disableVpcExternalIpv6"
  policy_for  = "folder"
  policy_type = "boolean"
  folder_id   = each.value
  enforce     = false
}

module "org_policies_restrict_protocol_fowarding_dev_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  constraint  = "constraints/compute.restrictProtocolForwardingCreationForTypes"
  policy_for  = "folder"
  folder_id   = local.fldr_development
  policy_type = "list"
  enforce     = false
}

module "org_policies_resource_location_constraint_dev_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = ">= 3.77" #"~> 3.0.2"

  constraint  = "constraints/gcp.resourceLocations"
  folder_id   = local.fldr_development
  policy_type = "list"
  policy_for  = "folder"
  enforce     = false
}

# Excluding network projects from the policy 
# For allowing Fortigate to pick image from a diiferent region.
module "org_policies_resource_location_constraint_dev_shared_ntwrk_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = ">= 3.77" #"~> 3.0.2"

  for_each    = toset(local.list_prj_dev_shared_network_exclude)
  constraint  = "constraints/gcp.resourceLocations"
  policy_for  = "project"
  policy_type = "list"
  project_id  = each.value
  enforce     = false
}

module "org_policies_require_trusted_images_dev_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  policy_for  = "folder" # Should be "organization" or "folder"
  folder_id   = local.fldr_development
  policy_type = "list"
  constraint  = "constraints/compute.trustedImageProjects"
  enforce     = false
}

module "org_policies_disable_guest_attribute_access_dev_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  policy_for  = "folder"
  folder_id   = local.fldr_development
  policy_type = "boolean"
  enforce     = false
  constraint  = "constraints/compute.disableGuestAttributesAccess"
}

module "org_vm_external_ip_access_dev_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  policy_for  = "folder" # Should be "organization" or "folder"
  folder_id   = local.fldr_development
  policy_type = "list"
  constraint  = "constraints/compute.vmExternalIpAccess"
  enforce     = false
}

module "org_vm_external_ip_access_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_prj_dev_shared_network_exclude)
  constraint  = "constraints/compute.vmExternalIpAccess"
  policy_for  = "project"
  policy_type = "list"
  project_id  = each.value
  enforce     = false
}

# /******************************************
#   Restrict Vpc Peering Override
# *******************************************/
module "org_policies_restrict_vpc_peering_prj_override" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.1" # Ensure compatibility with list_policy
  for_each    = toset(local.list_prj_dev_shared_network_exclude)
  policy_for  = "project"
  project_id  = each.value
  enforce     = false
  policy_type = "list"
  constraint  = "constraints/compute.restrictVpcPeering"
}

# /******************************************
#   Restrict LoadBalancer Creation For Types
# *******************************************/
module "org_policies_restricted_loadbalancer_types" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  policy_for        = "folder"
  folder_id         = local.fldr_development
  policy_type       = "list"
  constraint        = "constraints/compute.restrictLoadBalancerCreationForTypes"
  enforce           = false
}