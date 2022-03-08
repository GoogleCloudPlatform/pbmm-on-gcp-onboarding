/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


nonprod_host_net = {
  user_defined_string            = "nonp" # Must be globally unique. Used to create project name
  additional_user_defined_string = "hostproject"
  billing_account                = "########"
  services                       = [
                                    "logging.googleapis.com",
                                    "dns.googleapis.com", 
                                    "cloudbuild.googleapis.com",
                                    "dataflow.googleapis.com",
                                    "cloudfunctions.googleapis.com",
                                    "compute.googleapis.com",
                                    "pubsub.googleapis.com",
                                    "bigquery.googleapis.com",
                                    "servicenetworking.googleapis.com",
                                    "networkmanagement.googleapis.com",
                                    "sqladmin.googleapis.com"
                                    ]
  networks = [
    {
      network_name                           = "nonpvpc"
      description                            = "The Non-Production Shared VPC"
      routing_mode                           = "GLOBAL"
      shared_vpc_host                        = true
      auto_create_subnetworks                = false
      delete_default_internet_gateway_routes = true
      peer_project                           = "dcde-team-prod-perim" #Production Host Project Name <DepCodeEnvironementCodeLocationCode-owner-prodUserDefinedString-prodAdditionalUserDefinedString>
      peer_network                           = "dcdecnr-privperimvpc-vpc" #Production VPC Name <depcodeEnvironementCodeLocationCodeCNR-owner-prodUserDefinedString-vpc> privatePerimeterNet network name
      export_peer_custom_routes              = false
      subnets = [
        {
          subnet_name           = "nonproduction01"
          subnet_ip             = "10.108.128.0/24"
          subnet_region         = "northamerica-northeast1"
          subnet_private_access = true
          description           = "This subnet has a description"
          log_config = {
            aggregation_interval = "INTERVAL_5_SEC"
            flow_sampling        = 0.5
          }
          secondary_ranges = []
        }
      ]
      routes = []
      routers = []
      vpn_config = [
      ]
    }
  ]
  labels = {}
}