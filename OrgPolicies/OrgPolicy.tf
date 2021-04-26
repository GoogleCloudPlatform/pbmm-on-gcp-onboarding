##### Org policy to enforce resource deployment locations


module "org-policy" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 3.0.2"

  constraint        = "constraints/gcp.resourceLocations"
  policy_type       = "list"
  organization_id   = var.org_id
  allow             = ["northamerica-northeast1"]
  allow_list_length = 1
  policy_for = "organization"
}
