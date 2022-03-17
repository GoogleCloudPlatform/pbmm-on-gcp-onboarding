/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

public_perimeter_net = {
  user_defined_string            = "ppnetprd<RAND>" # must be globally unique
  additional_user_defined_string = "perimeter"
  billing_account                = "<BILLING_ACCOUNT>"
  services                       = ["logging.googleapis.com" , "dns.googleapis.com"]
  labels                         = {
    creator = "Jackson Yang"
  }
  networks = [
    {
      network_name                           = "pubperivpc<RAND>"
      description                            = "The Public Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "abse-go-prodnethost<RAND>-yp" # Production Host Project Name
      peer_network                           = "absecnr-testvpc-vpc" # Production VPC Name
      subnets = [
        {
          subnet_name           = "public"
          subnet_ip             = "10.30.0.0/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the public interface of the fortigate firewall"
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
private_perimeter_net = {
  user_defined_string            = "pvpnetprd<RAND>" # must be globally unique
  additional_user_defined_string = "perimeter"
  billing_account                = "<BILLING_ACCOUNT>"
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "priperivpc<RAND>"
      description                            = "The Private Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "abse-go-prodnethost<RAND>-yp" # Production Host Project Name
      peer_network                           = "absecnr-testvpc-vpc" # Production VPC Name
      subnets = [
        {
          subnet_name           = "private"
          subnet_ip             = "10.40.0.64/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the private interface of the fortigate firewall"
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
  user_defined_string            = "hapnetprd<RAND>" # must be globally unique
  additional_user_defined_string = "perimeter"
  billing_account                = "<BILLING_ACCOUNT>"
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "haperivpc<RAND>"
      description                            = "The HA Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "abse-go-prodnethost<RAND>-yp" # Production Host Project Name
      peer_network                           = "absecnr-testvpc-vpc" # Production VPC Name
      subnets = [
        {
          subnet_name           = "hasync"
          subnet_ip             = "10.10.0.128/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the HA Sync interface of the fortigate firewall"
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
  user_defined_string            = "mpnetprd<RAND>" # must be globally unique
  additional_user_defined_string = "perimeter"
  billing_account                = "<BILLING_ACCOUNT>"
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "mgmtperivpc<RAND>"
      description                            = "The Management Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "abse-go-prodnethost<RAND>-yp" # Production Host Project Name
      peer_network                           = "absecnr-testvpc-vpc" # Production VPC Name
      subnets = [
        {
          subnet_name           = "management"
          subnet_ip             = "10.10.0.192/26"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          subnet_flow_logs      = true
          description           = "This subnet is used for the management interface of the fortigate firewall"
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