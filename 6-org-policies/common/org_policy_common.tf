locals {
  folder_id = local.parent_folder != "" ? local.parent_folder : null
}

# /******************************************
#   Restrict Vpc Peering 
# *******************************************/
module "org_policies_restrict_vpc_peering" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.1" # Ensure compatibility with list_policy
  policy_for  = "folder"
  folder_id   = local.folder_id
  enforce     = true
  policy_type = "list"
  constraint  = "constraints/compute.restrictVpcPeering"
}
