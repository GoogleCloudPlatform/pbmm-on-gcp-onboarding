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


variable "roles" {
  type        = list(any)
  description = "List of roles to assign to the service account"
}

variable "folder" {
  type        = string
  description = "Folder to add roles to"
}

variable "member" {
  type        = string
  description = "Member to add roles to in the form of user:/group:/domain:account@email"
}