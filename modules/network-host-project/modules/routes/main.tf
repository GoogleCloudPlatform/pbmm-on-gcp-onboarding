/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

/******************************************
	Routes
 *****************************************/
resource "google_compute_route" "route" {
  project = var.project_id
  network = var.network_name

  name                   = module.route_name.result
  description            = var.description
  dest_range             = var.destination_range
  next_hop_gateway       = var.next_hop_gateway
  next_hop_ip            = var.next_hop_ip
  next_hop_instance      = var.next_hop_instance
  next_hop_instance_zone = var.next_hop_instance_zone
  next_hop_vpn_tunnel    = var.next_hop_vpn_tunnel
  priority               = var.priority
  tags                   = var.tags

  depends_on = [var.module_depends_on]
}
