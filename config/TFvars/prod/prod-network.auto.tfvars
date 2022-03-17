/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_host_net = {
  user_defined_string            = "prodnethost<RAND>" # Must be globally unique. Used to create project name
  additional_user_defined_string = "yp"
  billing_account                = "<BILLING_ACCOUNT>"
  services                       = ["logging.googleapis.com" , "dns.googleapis.com"]
  networks = [
    {
      network_name                           = "testvpc"
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
          subnet_ip             = "10.0.20.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [
            {
              range_name    = "additionalrange"
              ip_cidr_range = "10.0.21.0/24"
            }
          ]
        }
      ]
      routes = []
#     routes = [ #Optional
#       {
#         route_name                        = "egress-internet"
#         description                       = "route through IGW to access internet"
#         destination_range                 = "0.0.0.0/0"
#         next_hop_default_internet_gateway = true
#         next_hop_gateway                  = ""
#         next_hop_ip                       = ""
#         next_hop_instance                 = ""
#         next_hop_instance_zone            = ""
#         next_hop_vpn_tunnel               = ""
#         priority                          = 10000
#         tags                              = ["egress-inet"]
#       }
#     ]
      routers = []
#     routers = [ #Optional
#       {
#         router_name = ""
#         description = ""
#         region      = ""
#         bgp = {
#           asn               = 0
#           advertise_mode    = ""
#           advertised_groups = [""]
#           advertised_ip_ranges = [
#             {
#               range       = ""
#               description = ""
#             }
#           ]
#         }
#       }
#     ]
      vpn_config = []
#     vpn_config = [
#       {
#         ha_vpn_name     = ""
#         ext_vpn_name    = ""
#         vpn_tunnel_name = ""
#         peer_info = [
#           {
#             peer_asn        = ""
#             peer_ip_address = ""
#           }
#         ]
#         peer_external_gateway = {
#           redundancy_type = ""
#           interfaces = [
#             {
#               id              = ""
#               router_ip_range = ""
#               ip_address      = ""
#             }
#           ]
#         }
#         tunnels = {
#           # bgp_session_range   = ""
#           ike_version           = 0
#           vpn_gateway_interface = 0
#           # peer_external_gateway_interface = 0
#         }
#       }
#     ]
    }
  ]
  labels = {
    creator = "Jackson Yang"
  }
}