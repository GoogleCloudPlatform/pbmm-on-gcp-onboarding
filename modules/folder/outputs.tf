/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/
/*
output "folders" {
  description = "Folder resources as list."
  value       = local.folders_list
}*/

output "folders_map" {
  description = "Folder resources by name."
  value       = google_folder.folders
}

output "folders_map_1_level" {
  description = "Folder resources by name."
  value       = google_folder.one_level_folders
}

output "folders_map_2_levels" {
  description = "Folder resources by name."
  value       = google_folder.two_levels_folders
}

output "ids" {
  description = "Folder ids."
  value = { for name, folder in google_folder.folders :
    name => folder.name
  }
}

output "names" {
  description = "Folder names."
  value = { for name, folder in google_folder.folders :
    name => folder.display_name
  }
}/*

output "ids_list" {
  description = "List of folder ids."
  value       = local.folders_list[*].name
}

output "names_list" {
  description = "List of folder names."
  value       = local.folders_list[*].display_name
}*/