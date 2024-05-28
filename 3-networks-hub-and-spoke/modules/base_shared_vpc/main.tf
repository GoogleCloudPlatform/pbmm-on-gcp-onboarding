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

locals {
  mode                    = var.mode == "hub" ? "-hub" : "-spoke"
  vpc_name                = "${var.environment_code}-shared-base${local.mode}"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = module.private_service_connect.private_service_connect_ip
  // MRo: pr_option_seule_region
  region1_enabled = try(var.region1_enabled,true)
  region2_enabled = try(var.region2_enabled,false)
  // MRo: should have option for cloud_router non-HA
  router_ha_enabled = try(var.router_ha_enabled,true)
}

/******************************************
  Shared VPC configuration
 *****************************************/

module "main" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id                             = var.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = "true"
  delete_default_internet_gateway_routes = "true"

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
  // MRo: TODO routes already computed upstream including conditions
  routes = var.vpc_routes
  // MRo: TBD missing required parameters, TODO add them to var
}

/***************************************************************
  VPC Peering Configuration
 **************************************************************/
data "google_compute_network" "vpc_base_net_hub" {
  count   = var.mode == "spoke" ? 1 : 0
  name    = "vpc-c-shared-base-hub"
  project = var.base_net_hub_project_id
}

module "peering" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 9.0"
  count   = var.mode == "spoke" ? 1 : 0

  prefix                    = "np"
  local_network             = module.main.network_self_link
  peer_network              = data.google_compute_network.vpc_base_net_hub[0].self_link
  export_peer_custom_routes = true
}

/***************************************************************
  Configure Service Networking for Cloud SQL & future services.
 **************************************************************/

resource "google_compute_global_address" "private_service_access_address" {
  count         = var.private_service_cidr != null ? 1 : 0
  name          = "ga-${local.vpc_name}-vpc-peering-internal"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", var.private_service_cidr), 0)
  prefix_length = element(split("/", var.private_service_cidr), 1)
  network       = module.main.network_self_link

  depends_on = [module.peering]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.private_service_cidr != null ? 1 : 0
  network                 = module.main.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[0].name]

  depends_on = [module.peering]
}

/************************************
  Router to advertise shared VPC
  subnetworks and Google Private API
************************************/

module "region1_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region1_enabled && var.mode != "spoke") ? 1 : 0

  name    = "cr-${local.vpc_name}-${var.default_region1}-cr1"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = var.bgp_asn_subnet
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
  // MRo: TBD missing required parameters, TODO add them to var
}

module "region1_router2" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region1_enabled && var.router_ha_enabled && var.mode != "spoke") ? 1 : 0

  name    = "cr-${local.vpc_name}-${var.default_region1}-cr2"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = var.bgp_asn_subnet
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
  // MRo: TBD missing required parameters, TODO add them to var
}

module "region2_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region2_enabled && var.mode != "spoke") ? 1 : 0

  name    = "cr-${local.vpc_name}-${var.default_region2}-cr3"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region2
  bgp = {
    asn                  = var.bgp_asn_subnet
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
  // MRo: TBD missing required parameters, TODO add them to var
}

module "region2_router2" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region2_enabled && var.router_ha_enabled && var.mode != "spoke") ? 1 : 0

  name    = "cr-${local.vpc_name}-${var.default_region2}-cr4"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region2
  bgp = {
    asn                  = var.bgp_asn_subnet
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
  // MRo: TBD missing required parameters, TODO add them to var

}
