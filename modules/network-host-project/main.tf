/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

/*****************************************
   Project
  *****************************************/
module "project" {
  source                         = "../project"
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
  labels                         = local.labels
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  billing_account                = var.billing_account
  parent                         = var.parent
  services                       = var.services
  tf_service_account_email       = var.tf_service_account_email
  shared_vpc_host_config         = false
}

/******************************************
	Network configuration
 *****************************************/
module "network" {
  for_each                               = { for network in var.networks : network.network_name => network }
  source                                 = "./modules/network"
  project_id                             = module.project.project_id
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
  export_peer_custom_routes              = lookup(each.value, "export_peer_custom_routes", false)
  export_local_custom_routes             = lookup(each.value, "export_local_custom_routes", false)
  mtu                                    = lookup(each.value, "mtu", 1460)

  subnets = lookup(each.value, "subnets", {})
  routes  = lookup(each.value, "routes", [])
  routers = lookup(each.value, "routers", {})
  vpn_config = lookup(each.value, "vpn_config", [])
}
