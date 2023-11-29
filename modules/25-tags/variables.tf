/**
 * Copyright 2023 Google LLC
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
  description = "organization or project id of form organization/id or project/id"
}

variable "valuedescription" {
  type        = string
  description = "value description"
}

variable "keydescription" {
  type        = string
  description = "key description"
}

variable "valuename" {
  type        = string
  description = "key name"
}

variable "keyname" {
  type        = string
  description = "value name"
}