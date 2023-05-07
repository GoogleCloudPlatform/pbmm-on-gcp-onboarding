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

organization_config = {
  org_id          = "" # REQUIRED EDIT Numeric portion only '#############'"
  default_region  = "" # REQUIRED EDIT Cloudbuild Region
  department_code = "" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
  owner           = "" # REQUIRED EDIT Used in naming standard
  environment     = "" # REQUIRED EDIT S-Sandbox P-Production Q-Quality D-development
  location        = "" # REQUIRED EDIT Location used for resources. Currently northamerica-northeast1 is available
  labels          = {} # REQUIRED EDIT Object used for resource labels
  root_node       = "" # REQUIRED EDIT Organization Node in format "organizations/#############"
  contacts = {
    "user@email.com" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
  }
  billing_account = "" # REQUIRED EDIT Format of ######-######-######
}

