/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "sa_create_assign" {
  source = "./modules/sa_create_assign"

  for_each     = { for sa in local.sa_create_assign : sa.account_id => sa }
  project      = each.value.project
  account_id   = each.value.account_id
  display_name = each.value.display_name
  roles        = each.value.roles
}

module "project_iam" {
  source = "./modules/project_iam"

  for_each = { for account in local.project_iam : account.member => account }
  project  = each.value.project
  member   = each.value.member
  roles    = each.value.roles
}

module "compute_network_users" {
  source = "./modules/compute_network_user"

  for_each   = { for subnet in local.compute_network_users : subnet.subnetwork => subnet }
  project    = each.value.project
  region     = each.value.region
  subnetwork = each.value.subnetwork
  members    = each.value.members
}

module "folder_iam" {
  source = "./modules/folder_iam"
  count = length(var.folder_iam)
  #for_each = { for folder in var.folder_iam : format("%s-%s", folder.folder, folder.member) => folder }
  folder   = var.folder_iam[count.index].folder
  member   = var.folder_iam[count.index].member
  roles    = var.folder_iam[count.index].roles
}

module "organization_iam" {
  source = "./modules/organization_iam"

  for_each     = { for account in local.organization_iam : account.member => account }
  organization = each.value.organization
  member       = each.value.member
  roles        = each.value.roles
}