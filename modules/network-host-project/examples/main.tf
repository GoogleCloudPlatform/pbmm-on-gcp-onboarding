/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "random_string" "random_string" {
  length  = 4
  lower   = true
  special = false
  upper   = false
  number  = false
}

module "host_project" {
  source = "../"

  department_code                = var.department_code
  user_defined_string            = "HostNet${random_string.random_string.result}"
  additional_user_defined_string = "ut"
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location

  parent          = var.parent
  billing_account = var.billing_account
  services        = []

  network_name = "examplevpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "subnet01"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    },
  ]

  secondary_ranges = {
    subnet-01 = [
      {
        range_name    = "subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"

    },
  ]

  nat_name    = "natgateway01"
  router_name = "nat-router"
}