locals {
  list_p_prj_org_policy_requireShieldedVm_enforce = [
    local.prj_p_shared_restricted,
  ]
}

module "org_policies_require_shielded_vm_p_enforce" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each    = toset(local.list_p_prj_org_policy_requireShieldedVm_enforce)
  constraint  = "constraints/compute.requireShieldedVm"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  #   exclude_projects = []
  enforce = true
}
