/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_host_net = {
  user_defined_string            = "prod" # Must be globally unique. Used to create project name
  additional_user_defined_string = "hostproj"
  billing_account                = "#####"
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "prodvpc"
      description                            = "The Production Shared VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = true
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "dcde-team-prod-perim"
      peer_network                           = "dcdecnr-privperimvpc-vpc"
      export_peer_custom_routes              = true
      subnets = [
        {
          subnet_name           = "sharedinfrastructure"
          subnet_ip             = "10.108.1.0/25"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet used by the shared infrastructure project"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
          }
          secondary_ranges = []
        },
        {
          subnet_name           = "sharedservices"
          subnet_ip             = "10.108.1.128/25"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
          }
          secondary_ranges = []
        },
        {
          subnet_name           = "production01"
          subnet_ip             = "10.108.2.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
            metadata             = ""
          }
          secondary_ranges = [
          ]
        }                
      ]
      routes = []
      routers = []
      vpn_config = []
    }
  ]
  labels = {}
}