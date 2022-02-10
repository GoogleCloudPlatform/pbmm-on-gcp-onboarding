/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_compute_router" "router" {
  project = var.project_id
  network = var.network_name

  name        = module.router_name.result
  description = var.description
  region      = var.region


  dynamic "bgp" {
    for_each = var.bgp[*]
    content {
      asn               = bgp.value.asn
      advertise_mode    = lookup(bgp.value, "advertise_mode", null)
      advertised_groups = lookup(bgp.value, "advertised_groups", null)
      dynamic "advertised_ip_ranges" {
        for_each = bgp.value.advertised_ip_ranges == null ? [] : bgp.value.advertised_ip_ranges
        content {
          range       = advertised_ip_ranges.value.range
          description = lookup(advertised_ip_ranges.value, "description", "")
        }
      }
    }
  }
}

/******************************************
	VPN
*****************************************/
module "vpn" {
  for_each = { for vpn in var.vpn_config : vpn.ha_vpn_name => vpn }
  source                = "../vpn"
  project_id            = var.project_id
  department_code       = var.department_code
  environment           = var.environment
  region                = var.region
  location              = var.location
  network_name          = var.network_name
  router_name           = google_compute_router.router.name
  ha_vpn_name           = each.value.ha_vpn_name
  ext_vpn_name          = each.value.ext_vpn_name
  vpn_tunnel_name       = each.value.vpn_tunnel_name
  peer_info             = each.value.peer_info
  peer_external_gateway = each.value.peer_external_gateway
  tunnels               = each.value.tunnels
}