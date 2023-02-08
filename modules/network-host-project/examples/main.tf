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