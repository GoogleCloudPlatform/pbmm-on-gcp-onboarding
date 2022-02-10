/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_folder" "folders" {
  for_each = module.folder_names

  display_name = each.value.result
  parent       = var.parent
}

resource "google_folder" "one_level_folders" {
  for_each = module.one_level_folder_names

  display_name = each.value.result
  parent       = google_folder.folders[local.subfolders_1[each.value.result]].name
}

resource "google_folder" "two_levels_folders" {
  for_each = module.two_levels_folder_names

  display_name = each.value.result
  parent       = google_folder.one_level_folders[local.subfolders_2[each.value.result]].name
}