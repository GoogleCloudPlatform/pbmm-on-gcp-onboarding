
locals {
  list_p_prj_org_policy_requireShieldedVm_enforce = [
    local.prj_p_shared_restricted,
  ]

  list_prj_p_ntwrk_org_policy_override = [
    # local.prj_p_shared_restricted,
    local.prj_p_shared_base,
  ]
}

module "org_policies_require_shielded_vm_p_enforce" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  # for_each    = toset(local.list_p_prj_org_policy_requireShieldedVm_enforce)
  for_each = { for project_id in local.list_p_prj_org_policy_requireShieldedVm_enforce :
  project_id => project_id if project_id != null }
  constraint  = "constraints/compute.requireShieldedVm"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  #   exclude_projects = []
  enforce = true
}

# Excluding network projects from the policy 
# For allowing Fortigate to pick image from a diiferent region.
module "org_policies_resource_location_constraint_prod_ntwrk_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = ">= 3.77" #"~> 3.0.2"

  for_each    = toset(local.list_prj_p_ntwrk_org_policy_override)
  constraint  = "constraints/gcp.resourceLocations"
  policy_for  = "project"
  policy_type = "list"
  project_id  = each.value
  enforce     = false
}

module "org_policy_p_disableSerialPortAccess_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_prj_p_ntwrk_org_policy_override)
  constraint  = "constraints/compute.disableSerialPortAccess"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce     = false
}

module "org_policy_p_disableVpcExternalIpv6_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_prj_p_ntwrk_org_policy_override)
  constraint  = "constraints/compute.disableVpcExternalIpv6"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce     = false
}

module "org_vm_external_ip_access_prod_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  policy_for  = "project" # Should be "organization" or "folder"
  for_each    = toset(local.list_prj_p_ntwrk_org_policy_override)
  policy_type = "list"
  constraint  = "constraints/compute.vmExternalIpAccess"
  project_id  = each.value
  enforce     = false
}