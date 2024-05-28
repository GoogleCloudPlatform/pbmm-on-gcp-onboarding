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
  dns_hub_config               = module.dns_hub_config.dns_hub_config
  dns_hub_network_name         = local.dns_hub_config.dns_hub_network_name
  subnet_dns_hub               = local.dns_hub_config.subnet_dns_hub
  router_ha_enabled            = local.dns_hub_config.router_ha_enabled
  target_name_server_addresses = local.dns_hub_config.target_name_server_addresses
  vpc_routes                   = local.dns_hub_config.vpc_routes
  default_region1              = local.dns_hub_config.regions.region1.default
  region1_enabled              = local.dns_hub_config.regions.region1.enabled
  default_region2              = local.dns_hub_config.regions.region2.default
  region2_enabled              = local.dns_hub_config.regions.region2.enabled
  dns_vpc_ip_range             = local.dns_hub_config.dns_vpc_ip_range
 }

module "dns_hub_config" {
  source = "../../modules/nhas_config/dns_hub_config"
  config_file = abspath("${path.module}/../../vpc_config.yaml")
}

/******************************************
  DNS Hub VPC
*****************************************/
module "dns_hub_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id                             = local.dns_hub_project_id
  network_name                           = local.dns_hub_network_name
  shared_vpc_host                        = "false"
  delete_default_internet_gateway_routes = "true"

  subnets             = local.subnet_dns_hub

  routes = local.vpc_routes
  // MRo: missing required parameters, TODO add them to var
}

/******************************************
  Default DNS Policy
 *****************************************/

resource "google_dns_policy" "default_policy" {
  project                   = local.dns_hub_project_id
  name                      = "dp-dns-hub-default-policy"
  enable_inbound_forwarding = true
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.dns_hub_vpc.network_self_link
  }
}

/******************************************
 DNS Forwarding
*****************************************/

module "dns-forwarding-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 5.0"

  project_id = local.dns_hub_project_id
  type       = "forwarding"
  name       = "fz-dns-hub"
  domain     = var.domain

  private_visibility_config_networks = [
    module.dns_hub_vpc.network_self_link
  ]
  // target_name_server_addresses = var.target_name_server_addresses
  // MRo: pr_hardcodage_ip TODO use yaml config
  target_name_server_addresses = local.target_name_server_addresses
  // MRo: missing required parameters, TODO add them to var

}

/*********************************************************
  Routers to advertise DNS proxy range "35.199.192.0/19"
*********************************************************/
// MRo: pr_option_seul_cloud_router
module "dns_hub_region1_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region1_enabled) ? 1:0

  name    = "cr-c-dns-hub-${local.default_region1}-cr1"
  project = local.dns_hub_project_id
  network = module.dns_hub_vpc.network_name
  region  = local.default_region1
  bgp = {
    asn                  = local.dns_bgp_asn_number
    advertised_ip_ranges = [{ range = "35.199.192.0/19" }]
  }
  // MRo: missing required parameters, TODO add them to var
}

module "dns_hub_region1_router2" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region1_enabled && local.router_ha_enabled) ? 1:0

  name    = "cr-c-dns-hub-${local.default_region1}-cr2"
  project = local.dns_hub_project_id
  network = module.dns_hub_vpc.network_name
  region  = local.default_region1
  bgp = {
    asn                  = local.dns_bgp_asn_number
    advertised_ip_ranges = [{ range = "35.199.192.0/19" }]
  }
  // MRo: missing required parameters, TODO add them to var

}

module "dns_hub_region2_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region2_enabled) ? 1:0

  name    = "cr-c-dns-hub-${local.default_region2}-cr3"
  project = local.dns_hub_project_id
  network = module.dns_hub_vpc.network_name
  region  = local.default_region2
  bgp = {
    asn                  = local.dns_bgp_asn_number
    advertised_ip_ranges = [{ range = "35.199.192.0/19" }]
  }
  // MRo: missing required parameters, TODO add them to var

}

module "dns_hub_region2_router2" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  count   = (local.region2_enabled && local.router_ha_enabled) ? 1:0

  name    = "cr-c-dns-hub-${local.default_region2}-cr4"
  project = local.dns_hub_project_id
  network = module.dns_hub_vpc.network_name
  region  = local.default_region2
  bgp = {
    asn                  = local.dns_bgp_asn_number
    advertised_ip_ranges = [{ range = "35.199.192.0/19" }]
  }
  // MRo: missing required parameters, TODO add them to var

}
