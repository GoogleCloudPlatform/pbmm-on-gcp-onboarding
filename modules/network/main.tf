/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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
