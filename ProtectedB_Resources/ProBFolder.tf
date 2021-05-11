/**
 * Copyright 2021 Google LLC
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

#provider "google" {
#  region      = "${var.region}"
#  credentials = "${file("${var.credentials_file_path}")}"
#}



# Parent Protected B Folder
# Uncomment folder admin once IAM polices as per Orgganization needs have been decided
module  "ProtectedB" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  =  "${var.parent_type}/${var.parent_id}"

  names = [
    "ProtectedB",
  ]
set_roles = true

/*
  per_folder_admins = {
    admin = "group:admin-group@domain.com"
  }

  all_folder_admins = [
    "group:gcp-security@domain.com",
  ]
*/
}



