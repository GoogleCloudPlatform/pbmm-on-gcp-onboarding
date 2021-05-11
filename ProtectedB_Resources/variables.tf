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

###FOLDER Varibales##

variable "parent_id" {
  type        = string
  description = "Organization id"
}

variable "parent_type" {
  type        = string
  description = "Type of the parent resource. One of `organizations` or `folders`."
  default     = "organizations"
}

variable "names" {
  type        = list(string)
  description = "Folder names."
  default     = []
}

/*
variable "per_folder_admins" {
  type        = map(string)
  description = "IAM-style members per folder who will get extended permissions."
  default     = {}
}

variable "all_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members that will get the extended permissions across all the folders."
  default     = []
}
*/

variable "dept_name" {
  description = "Name for Shared Department"
}


#### PROJECT VARIABLES

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
}

variable "host_project_name" {
  description = "Name for Shared VPC host project"
  default     = "shared-vpc-host"
}


variable "network_name" {
  description = "Name for Shared VPC network"
  default     = "shared-network"
}

variable "service_project_name" {
  description = "Name for Shared VPC Service Project"
}



