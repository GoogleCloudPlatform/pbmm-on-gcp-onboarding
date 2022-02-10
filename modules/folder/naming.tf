/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "folder_names" {
  for_each = toset(local.parent_folders)
  source   = "../naming-standard//modules/gcp/folder"

  owner   = var.owner
  project = each.key
}

module "one_level_folder_names" {
  for_each = toset(local.subfolders_first_level)
  source   = "../naming-standard//modules/gcp/folder"

  owner   = var.owner
  project = each.key
}

module "two_levels_folder_names" {
  for_each = toset(local.subfolders_second_level)
  source   = "../naming-standard//modules/gcp/folder"

  owner   = var.owner
  project = each.key
}