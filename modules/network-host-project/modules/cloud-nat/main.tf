/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  # intermediate locals
  default_name                   = "cloud-nat"
  nat_ips_length                 = length(var.nat_ips)
  default_nat_ip_allocate_option = local.nat_ips_length > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  # locals for google_compute_router_nat
  nat_ip_allocate_option = var.nat_ip_allocate_option ? var.nat_ip_allocate_option : local.default_nat_ip_allocate_option
  name                   = var.nat_name != "" ? var.nat_name : local.default_name
}

resource "google_compute_router" "router" {
  name    = module.router_name.result
  project = module.project.project_id
  region  = var.region
  network = google_compute_network.network.name
  bgp {
    asn = var.router_asn
  }
}

resource "google_compute_router_nat" "main" {
  project                             = module.project.project_id
  region                              = var.region
  name                                = module.nat_name.result
  router                              = google_compute_router.router.name
  nat_ip_allocate_option              = local.nat_ip_allocate_option
  nat_ips                             = var.nat_ips
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
  min_ports_per_vm                    = var.min_ports_per_vm
  udp_idle_timeout_sec                = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.tcp_transitory_idle_timeout_sec
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping

  dynamic "subnetwork" {
    for_each = var.nat_subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = contains(subnetwork.value.source_ip_ranges_to_nat, "LIST_OF_SECONDARY_IP_RANGES") ? subnetwork.value.secondary_ip_range_names : []
    }
  }

  dynamic "log_config" {
    for_each = var.log_config_enable == true ? [{
      enable = var.log_config_enable
      filter = var.log_config_filter
    }] : []

    content {
      enable = log_config.value.enable
      filter = log_config.value.filter
    }
  }
}
















locals {
  routes = {
    for i, route in var.routes :
    lookup(route, "name", format("%s-%s-%d", lower(var.network_name), "route", i)) => route
  }
}

/******************************************
	Routes
 *****************************************/
resource "google_compute_route" "route" {
  for_each = local.routes

  project = var.project_id
  network = var.network_name

  name                   = module.route_names[each.key].result
  description            = lookup(each.value, "description", null)
  tags                   = compact(split(",", lookup(each.value, "tags", "")))
  dest_range             = lookup(each.value, "destination_range", null)
  next_hop_gateway       = lookup(each.value, "next_hop_internet", "false") == "true" ? "default-internet-gateway" : null
  next_hop_ip            = lookup(each.value, "next_hop_ip", null)
  next_hop_instance      = lookup(each.value, "next_hop_instance", null)
  next_hop_instance_zone = lookup(each.value, "next_hop_instance_zone", null)
  next_hop_vpn_tunnel    = lookup(each.value, "next_hop_vpn_tunnel", null)
  priority               = lookup(each.value, "priority", null)

  depends_on = [var.module_depends_on]
}
