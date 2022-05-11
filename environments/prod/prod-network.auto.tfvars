/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_host_net = {
  user_defined_string            = "prod" # Must be globally unique. Used to create project name
  # cycle the following string (make it temporarily random) for now until we implement a random suffix in the following gcp_folder_suffix
  # https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/44
  additional_user_defined_string = "host1"
  billing_account                = "REPLACE_WITH_BILLING_ID" ######-######-###### # required
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "prod-sharedvpc"
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
          subnet_name           = "subnet01"
          subnet_ip             = "10.10.20.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [# REQUIRED EDIT. Remove entire object in array if not using secondary ranges.
#            {
#              range_name    = ""
#              ip_cidr_range = ""
#            }
          ]
        }
      ]
      routes = [ # REQUIRED EDIT. Remove object if not using routes and leave as an empty array. If definind routes, only one of the following can be specified: next_hop_gateway,next_hop_ilb,next_hop_instance,next_hop_ip,next_hop_vpn_tunnel
#        {
#          route_name                        = "egress-internet"
#          description                       = "route through IGW to access internet"
#          destination_range                 = "0.0.0.0/0"
#          next_hop_default_internet_gateway = false
#          next_hop_gateway                  = ""
#          next_hop_ip                       = ""
#          next_hop_instance                 = ""
#          next_hop_instance_zone            = ""
#          next_hop_vpn_tunnel               = ""
#          priority                          = ""
#          tags                              = ["egress-inet"]
#        }
      ]
      routers = [ # REQUIRED EDIT. Remove all objects and leave as an empty array if not using routers.
#        {
#          router_name = ""
#          description = ""
#          region      = ""
#          bgp = {
#            asn               = 0
#            advertise_mode    = ""
#            advertised_groups = [""]
#            advertised_ip_ranges = [
#              {
#                range       = ""
#                description = ""
#              }
#            ]
#          }
#        }
      ]
      vpn_config = [ # REQUIRED EDIT. Remove all objects and leave as an empty array if not using vpn.
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
#          peer_external_gateway = { # REQUIRE EDIT. Remove entire object definition and object if not used
#            redundancy_type = ""
#            interfaces = [
#              {
#                id              = ""
#                router_ip_range = ""
#                ip_address      = ""
#              }
#            ]
#          }
#          tunnels = {# REQUIRE EDIT. Remove entire tunnel object definition and object if not used
#            bgp_session_range   = ""
#            ike_version           = 0
#            vpn_gateway_interface = 0
#            peer_external_gateway_interface = 0
#          }
#        }
      ]
    }
  ]
  labels = {}
}