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