/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

public_perimeter_net = {
  user_defined_string            = "obsprod" # must be globally unique
  additional_user_defined_string = "obspubper"#"perimeter"
  billing_account                = "REPLACE_BILLING_ID"#BILLING_ID #####-#####-#####
  services                       = ["logging.googleapis.com"]
  labels                         = {}
  networks = [
    {
      network_name                           = "obspubpervpc"
      description                            = "The obs Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
          subnet_name           = "publicobs"
          subnet_ip             = "10.100.0.0/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the public interface of the firewall" #fortigate firewall"
          log_config = {
            aggregation_interval = "INTERVAL_1_MIN"
            flow_sampling        = 0.5
          }
          secondary_ranges = []
        }
      ]
      routes  = []
#      routes  = [
#        {
#            route_name = "default-internet-gateway-onpremises-obs"
#            description = "Default route to the public internet"
#            destination_range = "3.210.101.209/32" # <on prem Public IP>
#            next_hop_default_internet_gateway = true
#            priority = 1000
#        }
#      ]
      routers = []
    }
  ]
}
private_perimeter_net = {
  user_defined_string            = "obsprod" # must be globally unique
  additional_user_defined_string = "obspriper"
  billing_account                = "REPLACE_BILLING_ID"#BILLING_ID #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "obspripervpc"
      description                            = "The Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
          subnet_name           = "privateobs"
          subnet_ip             = "10.108.0.64/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the private interface of the fireall" #fortigate firewall"
          log_config = {
            aggregation_interval = "INTERVAL_1_MIN"
            flow_sampling        = "0.5"
          }
          secondary_ranges = []
      }]
      routes  = []
      routers = []
    }
  ]
}

ha_perimeter_net = {
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "obshaper"#"perimeter"
  billing_account                = "REPLACE_BILLING_ID"#BILLING_ID #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "obshapervpc"
      description                            = "The ha Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
          subnet_name           = "hasync"
          subnet_ip             = "10.108.0.128/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the HA Sync interface of the firewall" #fortigate firewall"
          log_config = {
            aggregation_interval = "INTERVAL_1_MIN"
            flow_sampling        = "0.5"
          }
          secondary_ranges = []
        }
      ]
      routes  = []
      routers = []
    }
  ]
}

management_perimeter_net = {
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "obsperim" #"perimeter"
  billing_account                = "REPLACE_BILLING_ID"#BILLING_ID #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "obsmgmtper" # keep short as will be concat with the peer network name under 61 chars
      description                            = "The mgmt Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      # see prod-network and np-network
      peer_project                           = ""#"ospe-team-prod-perim" # Production Host Project Name
      # Error: "name" ("network-peering-ospecnr-obsmgmtperim-vpc-ospecnr-pubperimvpc-vpc") doesn't match regexp "^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$"
      peer_network                           = ""#"ospecnr-pubper-vpc" # Production VPC Name
      subnets = [
        {
          subnet_name           = "obsmanagement"
          subnet_ip             = "10.108.0.192/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the management interface of the firewall" #fortigate firewall"
          log_config = {
            aggregation_interval = "INTERVAL_1_MIN"
            flow_sampling        = 0.5
          }
          secondary_ranges = []
        }
      ]
      routes  = []
      routers = []
    }
  ]
}