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


variable "project" {
  type        = string
  description = "Project to change permissions in"
}

variable "roles" {
  type        = list(any)
  description = "List of roles to assign to email"
}

variable "member" {
  type        = string
  description = "GCP account to apply roles to, must be in the form of (user|group|serviceAccount|domain):email@domain.com "
}