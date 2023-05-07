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



locals {
  parent_type   = var.parent == null ? null : split("/", var.parent)[0]
  parent_id     = var.parent == null ? null : split("/", var.parent)[1]
  create_roles  = var.tf_service_account_email == null || var.tf_service_account_email == "" ? false : true
  project_roles = [
    "roles/source.admin",
    "roles/secretmanager.secretAccessor",
    "roles/resourcemanager.projectMover",
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin",
  ]
}