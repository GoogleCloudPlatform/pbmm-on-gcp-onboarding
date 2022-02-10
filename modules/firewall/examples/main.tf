/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "random_id" "project_suffix" {
  byte_length = 2
}

module "project" {
  source                         = "../../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = "NonScedHostFW"
  additional_user_defined_string = random_id.project_suffix.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services                       = []
}

resource "google_compute_network" "network" {
  name                            = "example-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  project                         = module.project.project_id
  description                     = "Unit Test Network"
  delete_default_routes_on_create = true
  mtu                             = 1500
}

module "firewall" {
  source               = "../"
  project_id           = module.project.project_id
  network              = google_compute_network.network.name
  custom_rules         = local.custom_rules
  enable_bastion_ports = true
  environment          = var.environment
  department_code      = var.department_code
  location             = var.location

  custom_iap_rules = {
    port-80 = {
      rule_name = "my-project-port-80"
      protocol  = "tcp"
      ports     = ["80"]
    }
  }
}
