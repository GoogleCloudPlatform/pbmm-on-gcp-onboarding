data "google_compute_subnetwork" "hub" {
  self_link            = var.day0.internal_subnet
}
/*
data "google_compute_network" "spoke" {
  name                 = var.vpc_name
  project              = var.vpc_project
}

# Auto-discover list of CIDRs for FGT routing (works only for pre-existing networks)
data "google_compute_subnetwork" "spoke_subnets" {
  for_each             = toset(data.google_compute_network.spoke.subnetworks_self_links)
  self_link            = each.key
}

locals {
  spoke_ip_cidr_ranges = toset([for subnet in data.google_compute_subnetwork.spoke_subnets : subnet.ip_cidr_range])
}
*/

locals {
  spoke_ip_cidr_ranges = var.spoke_ip_cidr_ranges
  spoke_self_link      = var.spoke_self_link
}

resource "google_compute_network_peering" "hub_to_spoke" {
  name                 = "peer-fgthub-to-${var.vpc_name}-${var.vpc_project}"
  network              = data.google_compute_subnetwork.hub.network
//  peer_network         = data.google_compute_network.spoke.self_link
  peer_network         = local.spoke_self_link
  export_custom_routes = true
}

resource "google_compute_network_peering" "spoke_to_hub" {
  name                 = "peer-${var.vpc_name}-${var.vpc_project}-to-fgthub"
  network              = var.spoke_self_link
//  network              = data.google_compute_network.spoke.self_link
  peer_network         = data.google_compute_subnetwork.hub.network
  import_custom_routes = true
  depends_on           = [
    google_compute_network_peering.hub_to_spoke
  ]
}

resource "fortios_router_static" "to_spoke_subnets" {
  for_each             = local.spoke_ip_cidr_ranges
  dst                  = each.key
  gateway              = data.google_compute_subnetwork.hub.gateway_address
  device               = "port2"
}
