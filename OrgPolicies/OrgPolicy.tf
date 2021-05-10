##### Org policy to enforce resource deployment locations



module "domain-restricted-sharing" {
  source           = "terraform-google-modules/terraform-google-org-policy/modules/domain_restricted_sharing"
  policy_for       = "organization"
  organization_id  = var.organization_id
  domains_to_allow = var.domains_to_allow
}




module "shielded-vms" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"

  constraint        = "constraints/compute.requireShieldedVm"
  policy_type       = "list"
  organization_id   = var.organization_id
  enforce           = true
}



module "trusted-image" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  
  constraint        = "constraints/compute.trustedImageProjects"
  policy_type       = "list"
  organization_id   = var.organization_id
  enforce           = true
}


module "os-login" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  
  constraint        = "constraints/compute.requireOsLogin"
  policy_type       = "list"
  organization_id   = var.organization_id
  enforce           = true
}



