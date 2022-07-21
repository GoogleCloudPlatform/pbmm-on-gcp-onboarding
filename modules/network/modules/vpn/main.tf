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




resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  project  = var.project_id
  network  = var.network_name
  region   = var.region
  name     = module.ha_vpn_name.result
}

resource "google_compute_external_vpn_gateway" "external_gateway" {
  project  = var.project_id
  name     = module.ext_vpn_name.result
  redundancy_type = var.peer_external_gateway.redundancy_type
  dynamic "interface" {
    for_each = var.peer_external_gateway.interfaces
    content {
      id         = interface.value.id
      ip_address = interface.value.ip_address
    }
  }
}

resource "google_compute_vpn_tunnel" "tunnels" {
  for_each                        = { for peer in var.peer_external_gateway.interfaces : peer.id => peer }
  project                         = var.project_id
  region                          = var.region
  name                            = module.vpn_tunnel_name[each.key].result
  router                          = var.router_name
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.self_link
  peer_external_gateway_interface = each.value.id
  vpn_gateway_interface           = each.value.id
  ike_version                     = var.tunnels.ike_version
  shared_secret                   = random_id.secret.b64_url
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.self_link
}

resource "google_compute_router_interface" "interface" {
  for_each   = { for peer in var.peer_external_gateway.interfaces : peer.id => peer }
  project    = var.project_id
  name       = "${var.router_name}-interface-${each.value.id}"
  router     = var.router_name
  region     = var.region
  ip_range   = each.value.router_ip_range
  vpn_tunnel = google_compute_vpn_tunnel.tunnels[each.value.id].self_link
}

resource "google_compute_router_peer" "router_peer" {
  for_each        = { for peer in var.peer_info : peer.peer_asn => peer}
  project         = var.project_id
  name            = "${var.router_name}-peer-${each.value.peer_asn}"
  router          = var.router_name
  region          = var.region
  peer_asn        = each.value.peer_asn
  peer_ip_address = each.value.peer_ip_address
  interface       = "${var.router_name}-interface-${index(var.peer_info, each.value)}"

  depends_on = [
      google_compute_router_interface.interface
  ]
}

resource "random_id" "secret" {
  byte_length = 8
}