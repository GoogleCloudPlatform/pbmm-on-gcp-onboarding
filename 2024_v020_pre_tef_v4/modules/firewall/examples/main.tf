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


resource "random_id" "project_suffix" {
  byte_length = 2
}

module "project" {
  source                         = "../../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = "NonScedHostFW"
  additional_user_defined_string = random_id.project_suffix.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services                       = []
}

resource "google_compute_network" "network" {
  name                            = "example-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  project                         = module.project.project_id
  description                     = "Unit Test Network"
  delete_default_routes_on_create = true
  mtu                             = 1500
}

module "firewall" {
  source               = "../"
  project_id           = module.project.project_id
  network              = google_compute_network.network.name
  custom_rules         = local.custom_rules
  enable_bastion_ports = true
  environment          = var.environment
  department_code      = var.department_code
  location             = var.location

  custom_iap_rules = {
    port-80 = {
      rule_name = "my-project-port-80"
      protocol  = "tcp"
      ports     = ["80"]
    }
  }
}
