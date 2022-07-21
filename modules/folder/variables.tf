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


variable "parent" {
  type        = string
  description = "The resource name of the parent Folder or Organization. Must be of the form folders/folder_id or organizations/org_id"
}

variable "owner" {
  type        = string
  description = "Division or group responsible for security and financial commitment."
  default     = ""
}

variable "names" {
  type        = list(string)
  description = "Folder names."
  default     = []
}

variable "subfolders_first_level" {
    type        = map
    description = "Sub-folders and their parent folder"
    default     = {}
}

variable "subfolders_second_level" {
    type        = map
    description = "Sub-folders and their parent folder"
    default     = {}
}