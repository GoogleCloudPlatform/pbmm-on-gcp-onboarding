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


variable "account_id" {
  type        = string
  description = "ID for account email address, will be combined in output from naming module"
}
variable "display_name" {
  type        = string
  description = "Display name for service account"

}

variable "roles" {
  type        = list(string)
  description = "List of roles to assign to the service account"
}

variable "project" {
  type        = string
  description = "Location to place SA in"
}