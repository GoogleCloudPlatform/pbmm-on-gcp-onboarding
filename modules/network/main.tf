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



/******************************************
	Network configuration
 *****************************************/
module "network" {
  for_each                               = { for network in var.networks : network.network_name => network }
  source                                 = "./modules/network"
  project_id                             = var.project_id
  department_code                        = var.department_code
  environment                            = var.environment
  location                               = var.location
  additional_user_defined_string         = var.additional_user_defined_string
  network_name                           = each.value.network_name
  auto_create_subnetworks                = lookup(each.value, "auto_create_subnetworks", "false")
  routing_mode                           = lookup(each.value, "routing_mode", "GLOBAL")
  description                            = lookup(each.value, "description", "")
  shared_vpc_host                        = lookup(each.value, "shared_vpc_host", false)
  delete_default_internet_gateway_routes = lookup(each.value, "delete_default_internet_gateway_routes", false)
  peer_project                           = lookup(each.value, "peer_project", "")
  peer_network                           = lookup(each.value, "peer_network", "")
  mtu                                    = lookup(each.value, "mtu", 1460)

  subnets    = lookup(each.value, "subnets", {})
  routes     = lookup(each.value, "routes", [])
  routers    = lookup(each.value, "routers", {})
  vpn_config = lookup(each.value, "vpn_config", [])
}
