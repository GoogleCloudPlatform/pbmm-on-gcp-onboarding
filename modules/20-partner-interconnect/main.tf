/**
 * Copyright 2023 Google LLC
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
  Partner Interconnect
*****************************************/

# start with https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment

/*locals {
  suffix1 = lookup(var.cloud_router_labels, "vlan_1", "cr1")
  suffix2 = lookup(var.cloud_router_labels, "vlan_2", "cr2")
}*/

resource "google_compute_interconnect_attachment" "on_prem1" {
  name                     = var.region1_vlan1_name
  #name = "vl-${var.region1_interconnect1_onprem_dc}-${var.region1_interconnect1_location}-${var.vpc_name}-${var.region1}-${local.suffix1}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router1.id
  project = var.interconnect_router_project_id
  region = var.region1
  mtu                      = 1500
  admin_enabled            = var.preactivate
}

resource "google_compute_interconnect_attachment" "on_prem2" {
  name                     = var.region1_vlan2_name
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  type                     = "PARTNER"
  router                   = google_compute_router.router1.id
  project = var.interconnect_router_project_id
  region = var.region1
  mtu                      = 1500
  admin_enabled            = var.preactivate
}

resource "google_compute_interconnect_attachment" "on_prem3" {
  name                     = var.region1_vlan3_name
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router1.id
  project = var.interconnect_router_project_id
  region = var.region1
  mtu                      = 1500
  admin_enabled            = var.preactivate
}

resource "google_compute_interconnect_attachment" "on_prem4" {
  name                     = var.region1_vlan4_name
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  type                     = "PARTNER"
  router                   = google_compute_router.router1.id
  project = var.interconnect_router_project_id
  region = var.region1
  mtu                      = 1500
  admin_enabled            = var.preactivate
}

resource "google_compute_router" "router1" {
  name    = var.interconnect_router_name
  network = var.interconnect_vpc_name 
  region = var.region1
  project = var.interconnect_router_project_id
  bgp {
    asn = 16550
  }
}
