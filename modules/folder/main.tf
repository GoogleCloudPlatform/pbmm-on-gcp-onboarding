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