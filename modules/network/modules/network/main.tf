/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                 = "../vpc"
  project_id                             = var.project_id
  department_code                        = var.department_code
  environment                            = var.environment
  location                               = var.location
  network_name                           = var.network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  routing_mode                           = var.routing_mode
  description                            = var.description
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  peer_project                           = var.peer_project
  peer_network                           = var.peer_network
  mtu                                    = var.mtu
}

/******************************************
	Subnet configuration
 ******************************************/
module "subnets" {
  for_each = { for subnet in var.subnets : subnet.subnet_name => subnet }
  source   = "../subnets"

  project_id                     = var.project_id
  department_code                = var.department_code
  environment                    = var.environment
  location                       = var.location
  additional_user_defined_string = var.additional_user_defined_string
  network_name                   = module.vpc.network_name

  subnet_name           = each.value.subnet_name
  description           = lookup(each.value, "description", "")
  subnet_private_access = lookup(each.value, "subnet_private_access", false)
  subnet_region         = lookup(each.value, "subnet_region", "northamerica-northeast1")
  subnet_ip             = each.value.subnet_ip

  secondary_ranges = lookup(each.value, "secondary_ranges", [])
  log_config       = lookup(each.value, "log_config", {})
}

/******************************************
	Route
 *****************************************/
module "routes" {
  for_each = { for route in var.routes : route.route_name => route }
  source   = "../routes"

  project_id   = var.project_id
  network_name = module.vpc.network_name

  route_name             = each.value.route_name
  description            = lookup(each.value, "description", "")
  destination_range      = lookup(each.value, "destination_range", null)
  next_hop_gateway       = lookup(each.value, "next_hop_default_internet_gateway", false) == true ? "default-internet-gateway" : lookup(each.value, "next_hop_gateway", null)
  next_hop_ip            = lookup(each.value, "next_hop_ip", null)
  next_hop_instance      = lookup(each.value, "next_hop_instance", null)
  next_hop_instance_zone = lookup(each.value, "next_hop_instance_zone", null)
  next_hop_vpn_tunnel    = lookup(each.value, "next_hop_vpn_tunnel", null)
  priority               = lookup(each.value, "priority", 1000)
  tags                   = lookup(each.value, "tags", [])

  module_depends_on = [module.subnets]
}

/******************************************
	Router
 *****************************************/

module "router" {
  for_each = { for router in var.routers : router.router_name => router }
  source   = "../router"

  project_id      = var.project_id
  department_code = var.department_code
  environment     = var.environment
  location        = var.location
  network_name    = module.vpc.network_name
  vpn_config      = var.vpn_config
  router_name = each.value.router_name
  description = lookup(each.value, "description", "")
  region      = lookup(each.value, "region", "northamerica-northeast1")

  bgp = lookup(each.value, "bgp", {})
}