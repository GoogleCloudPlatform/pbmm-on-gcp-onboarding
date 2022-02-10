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
  description = "The Owner of the Projects within the folder"
  default     = ""
}

variable "names" {
  type        = list(string)
  description = "Folder names."
  default     = []
}