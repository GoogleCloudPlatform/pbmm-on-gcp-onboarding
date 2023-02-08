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



resource "random_id" "random_id" {
  byte_length = 2
}

module "project" {
  source = "../"

  department_code                = var.department_code
  user_defined_string            = "UTHostProj"
  additional_user_defined_string = random_id.random_id.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location

  billing_account = var.billing_account
  parent          = var.parent
  services = [
    "appengine.googleapis.com"
  ]
  policy_boolean = {
    "constraints/compute.skipDefaultNetworkCreation" = true
  }
  policy_list = {
    "constraints/compute.trustedImageProjects" = {
      inherit_from_parent = null
      suggested_value     = null
      status              = true
      values              = ["projects/gce-uefi-images"]
    }
  }

  shared_vpc_host_config  = true
  iap_tunnel_members_list = var.iap_tunnel_members_list
}

module "service_project" {
  source = "../"

  department_code                = var.department_code
  user_defined_string            = "UTSvcProj"
  additional_user_defined_string = random_id.random_id.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location

  billing_account = var.billing_account
  parent          = var.parent

  shared_vpc_service_config = {
    attach       = true
    host_project = module.project.project_id
  }

  depends_on = [
    module.project
  ]
}