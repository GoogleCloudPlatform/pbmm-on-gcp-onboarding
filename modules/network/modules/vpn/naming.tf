/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "ha_vpn_name" {
  source = "../../../naming-standard//modules/gcp/ha_vpn_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = var.ha_vpn_name
}

module "ext_vpn_name" {
  source = "../../../naming-standard//modules/gcp/external_vpn_name"

  department_code     = var.department_code
  environment         = var.environment
  location            = var.location
  user_defined_string = var.ext_vpn_name
}

module "vpn_tunnel_name" {
  for_each        = { for peer in var.peer_external_gateway.interfaces : peer.id => peer }
  source          = "../../../naming-standard//modules/gcp/vpn_tunnel_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location
  number_suffix   = each.value.id
  user_defined_string = var.vpn_tunnel_name
}
