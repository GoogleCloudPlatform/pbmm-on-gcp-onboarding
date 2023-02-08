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

prod_host_net = {
  user_defined_string            = "prod" # Must be globally unique. Used to create project name
  additional_user_defined_string = "host1"
  billing_account                = "REPLACE_WITH_BILLING_ID" ######-######-###### # required
  services                       = ["logging.googleapis.com", "dns.googleapis.com"]
  networks = [
    {
      network_name                           = "prod-shared-zone1"
      description                            = "The Production Shared VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = true
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = ""
      peer_network                           = ""
      export_peer_custom_routes              = false
      export_local_custom_routes             = false
      mtu                                    = 0
      subnets = [
        {
          subnet_name           = "prod-zone1-web"
          subnet_ip             = "10.10.20.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [ # REQUIRED EDIT. Remove entire object in array if not using secondary ranges.
            #            {
            #              range_name    = ""
            #              ip_cidr_range = ""
            #            }
          ]
        },
        {
          subnet_name           = "prod-zone1-app"
          subnet_ip             = "10.20.20.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [ # REQUIRED EDIT. Remove entire object in array if not using secondary ranges.
            #            {
            #              range_name    = ""
            #              ip_cidr_range = ""
            #            }
          ]
        },
        {
          subnet_name           = "prod-zone1-db"
          subnet_ip             = "10.20.30.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [ # REQUIRED EDIT. Remove entire object in array if not using secondary ranges.
            #            {
            #              range_name    = ""
            #              ip_cidr_range = ""
            #            }
          ]
        }
      ]
      routes = [ # REQUIRED EDIT. Remove object if not using routes and leave as an empty array. If definind routes, only one of the following can be specified: next_hop_gateway,next_hop_ilb,next_hop_instance,next_hop_ip,next_hop_vpn_tunnel
        {
          route_name                        = "google-apis-zone1"
          description                       = "Route through default-internet-gateway to access google apis"
          destination_range                 = "199.36.153.4/30"
          next_hop_default_internet_gateway = false
          next_hop_gateway                  = "default-internet-gateway"
          priority                          = 0
          tags                              = []
        },
        {
          route_name                        = "egress-internet-zone1"
          description                       = "Route through IGW to access internet"
          destination_range                 = "0.0.0.0/0"
          next_hop_default_internet_gateway = true
          next_hop_gateway                  = ""
          priority                          = 0
          tags                              = ["egress-inet"]
        }
      ]
      routers = [ # REQUIRED EDIT. If not using reouters, remove all objects and leave as an empty array. 
        {
          router_name = "egress-internet-nat-zone1"
          description = "NAT gateway router in region northamerica-northeast1"
          region      = "northamerica-northeast1"
          bgp = {
            asn = 64515
          }
        }
      ]
      nat_config = [ # REQUIRED EDIT. If not using nat, remove all objects and leave as an empty array. 
        {
          nat_name    = "egress-internet-zone1"
          router_name = "egress-internet-nat-zone1"
          description = "NAT gateway for egress internet access in region northamerica-northeast1"
          region      = "northamerica-northeast1"
        }
      ]
      vpn_config = [ # REQUIRED EDIT. If not using vpn_config, remove all objects and leave as an empty array.
        #        {
        #          ha_vpn_name     = ""
        #          ext_vpn_name    = ""
        #          vpn_tunnel_name = ""
        #          peer_info = [
        #            {
        #              peer_asn        = ""
        #              peer_ip_address = ""
        #            }
        #          ]
        #          peer_external_gateway = {
        #            redundancy_type = ""
        #            interfaces = [
        #              {
        #                id              = ""
        #                router_ip_range = ""
        #                ip_address      = ""
        #              }
        #            ]
        #          }
        #          tunnels = { # REQUIRE EDIT. Remove entire tunnel object definitions and object if not used
        #            bgp_session_range   = ""
        #            ike_version           = 0
        #            vpn_gateway_interface = 0
        #            peer_external_gateway_interface = 0
        #          }
        #        }
      ]
    },
    {
      network_name                           = "prod-shared-zone2"
      description                            = "The Production Shared VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = true
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = ""
      peer_network                           = ""
      export_peer_custom_routes              = false
      export_local_custom_routes             = false
      mtu                                    = 0
      subnets = [
        {
          subnet_name           = "prod-zone2"
          subnet_ip             = "10.10.24.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [ # REQUIRED EDIT. Remove entire object in array if not using secondary ranges.
            #            {
            #              range_name    = ""
            #              ip_cidr_range = ""
            #            }
          ]
        }
      ]
      routes = [ # REQUIRED EDIT. Remove object if not using routes and leave as an empty array. If definind routes, only one of the following can be specified: next_hop_gateway,next_hop_ilb,next_hop_instance,next_hop_ip,next_hop_vpn_tunnel
        {
          route_name                        = "google-apis-zone2"
          description                       = "Route through default-internet-gateway to access google apis"
          destination_range                 = "199.36.153.4/30"
          next_hop_default_internet_gateway = false
          next_hop_gateway                  = "default-internet-gateway"
          priority                          = 0
          tags                              = []
        },
        {
          route_name                        = "egress-internet-zone2"
          description                       = "Route through IGW to access internet"
          destination_range                 = "0.0.0.0/0"
          next_hop_default_internet_gateway = true
          next_hop_gateway                  = ""
          priority                          = 0
          tags                              = ["egress-inet"]
        }
      ]
      routers = [ # REQUIRED EDIT. If not using reouters, remove all objects and leave as an empty array. 
        {
          router_name = "egress-internet-nat-zone2"
          description = "NAT gateway router in region northamerica-northeast1"
          region      = "northamerica-northeast1"
          bgp = {
            asn = 64516
          }
        }
      ]
      nat_config = [ # REQUIRED EDIT. If not using nat, remove all objects and leave as an empty array. 
        {
          nat_name    = "egress-internet-zone2"
          router_name = "egress-internet-nat-zone2"
          description = "NAT gateway for egress internet access in region northamerica-northeast1"
          region      = "northamerica-northeast1"
        }
      ]
      vpn_config = [ # REQUIRED EDIT. If not using vpn_config, remove all objects and leave as an empty array.
        #        {
        #          ha_vpn_name     = ""
        #          ext_vpn_name    = ""
        #          vpn_tunnel_name = ""
        #          peer_info = [
        #            {
        #              peer_asn        = ""
        #              peer_ip_address = ""
        #            }
        #          ]
        #          peer_external_gateway = {
        #            redundancy_type = ""
        #            interfaces = [
        #              {
        #                id              = ""
        #                router_ip_range = ""
        #                ip_address      = ""
        #              }
        #            ]
        #          }
        #          tunnels = { # REQUIRE EDIT. Remove entire tunnel object definitions and object if not used
        #            bgp_session_range   = ""
        #            ike_version           = 0
        #            vpn_gateway_interface = 0
        #            peer_external_gateway_interface = 0
        #          }
        #        }
      ]
    }
  ]
  labels = {
    creator          = "jackson",
    department       = "gcp",
    application_name = "hostvpc"
    environment      = "prod"
  }
}
