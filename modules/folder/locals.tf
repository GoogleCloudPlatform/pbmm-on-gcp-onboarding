/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {

  full_folder_list = toset(concat(var.names, keys(var.subfolders_first_level), keys(var.subfolders_second_level)))

  parent_folders = var.names
  subfolders_1 = var.subfolders_first_level
  subfolders_2 = var.subfolders_second_level
  subfolders_first_level = toset(keys(var.subfolders_first_level))
  subfolders_second_level = toset(keys(var.subfolders_second_level))


  parent_folders_list = [for name in local.parent_folders : google_folder.folders[name]]
  #sub_folders_1_list = [for name in local.subfolders_first_level : google_folder.one_level_folders[name]]
  #sub_folders_2_list = [for name in local.subfolders_second_level : google_folder.two_levels_folders[name]]

  #folders_list = concat(local.parent_folders_list, local.sub_folders_1_list, local.sub_folders_2_list)
}