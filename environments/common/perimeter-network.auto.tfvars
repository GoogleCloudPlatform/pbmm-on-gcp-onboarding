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



public_perimeter_net = {
  user_defined_string            = "prd" # REQUIRED EDIT must contribute to being globally unique
  additional_user_defined_string = "perim" # OPTIONAL EDIT check 61 char aggregate limit
  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  labels                         = {}
  networks = [
    {
      network_name                           = "pubpervpc" # Optional Edit
      description                            = "The Public Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
          subnet_name           = "public" # Optional edit
          subnet_ip             = "10.10.0.0/26" # Recommended Edit
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
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "priper" # check 61 char aggregate limit
  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "privpervpc" #Optional Edit
      description                            = "The Private Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
      subnets = [
        {
          subnet_name           = "private"
          subnet_ip             = "10.10.0.64/26" #Recommended Edit
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
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "perim" # check 61 char agreggate limit
  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "<ha-perimeter-vpc-name>" # REQUIRED EDIT - example: depthaper
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
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "perim" # check 61 char aggregate limit
  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
  services                       = ["logging.googleapis.com"]
  networks = [
    {
      network_name                           = "<management-perimeter-vpc-name>" # REQUIRED EDIT - example: deptmgmtper
      description                            = "The Perimeter VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = false
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "" # Production Host Project Name
      peer_network                           = "" # Production VPC Name
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
