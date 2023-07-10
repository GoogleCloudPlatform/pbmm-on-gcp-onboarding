module "cs-common" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.2"

  parent = "organizations/${var.org_id}"
  names = [
    "Common",
  ]
}

module "cs-divisions" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.2"

  parent = "organizations/${var.org_id}"
  names = [
    "Department 1",
  ]
}

module "cs-teams" {
  for_each = module.cs-divisions.ids
  source   = "terraform-google-modules/folders/google"
  version  = "~> 3.2"

  parent = each.value
  names = [
    "Team 1",
  ]
}

module "cs-envs" {
  for_each = merge([for grandParentFolderName, parentFolder in module.cs-teams : { for parentFolderName, id in parentFolder.ids : "${grandParentFolderName}-${parentFolderName}" => id }]...)
  source   = "terraform-google-modules/folders/google"
  version  = "~> 3.2"

  parent = each.value
  names = [
    "Production",
    "Non-Production",
    "Development",
  ]
}
