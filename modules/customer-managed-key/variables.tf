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

variable "project_id" {
  description = "project ID to use for creating customer managed keys."
  default     = ""
  type        = string
}

variable "project_number" {
  description = "project number to use for populating kms supported service agents."
  default     = ""
  type        = string
}

variable "default_region" {
  type    = string
  default = "northamerica-northeast1"
}

variable "enable_default_global_cmk" {
  description = "If create the default global cmk"
  type        = bool
  default     = false
}

variable "kms_encrypterdecrypter_members_list" {
  description = "list of users to grant cryptoKeyEncrypterDecrypter role"
  type        = list(string)
  default     = []
}

variable "cmk_encrypterdecrypter_members" {
  type        = list(string)
  description = "CMK encrypter/decrypter iam members."
  default     = []
}
