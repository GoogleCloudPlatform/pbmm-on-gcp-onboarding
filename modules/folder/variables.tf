/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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