/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

public_perimeter_net = {
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "perim"
  billing_account                = "#####" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  labels                         = {}
  networks = [
    {
      network_name                           = "pubperimvpc"
      description                            = "The Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name 
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
            subnet_name           = "public"
            subnet_ip             = "10.108.0.0/26"
            subnet_region         = "northamerica-northeast1"
            subnet_private_access = true
            subnet_flow_logs      = true
            description           = "This subnet is used for the public interface of the firewall"
            log_config = {
                aggregation_interval = "INTERVAL_1_MIN"
                flow_sampling        = 0.5
            }
            secondary_ranges = []
        }
      ]
      routes  = [
        {
            route_name = "default-internet-gateway-onpremises"
            description = "Default route to the public internet"
            destination_range = "000.000.000.0/32" # <on prem Public IP>
            next_hop_default_internet_gateway = true
            priority = 1000
        }
      ]
      routers = []
    }
  ]
}
private_perimeter_net = {
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "perim"
  billing_account                = "#####" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "privperimvpc"
      description                            = "The Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
          subnet_name           = "private"
          subnet_ip             = "10.108.0.64/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the private interface of the firewall"
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
  additional_user_defined_string = "perim"
  billing_account                = "#####" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "haperimvpc"
      description                            = "The Perimeter VPC"
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
          description           = "This subnet is used for the HA Sync interface of the firewall"
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
  additional_user_defined_string = "perim"
  billing_account                = "#####" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "mgmtperim"
      description                            = "The Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "dcde-team-prod-perim" # Production Host Project Name
      peer_network                           = "dcdecnr-pubperimvpc-vpc" # Production VPC Name
      subnets = [
        {
          subnet_name           = "management"
          subnet_ip             = "10.108.0.192/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the management interface of the  firewall"
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