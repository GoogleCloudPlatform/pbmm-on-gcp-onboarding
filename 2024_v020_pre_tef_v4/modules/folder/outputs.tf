/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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