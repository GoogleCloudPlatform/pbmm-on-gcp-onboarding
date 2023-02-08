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
  upper   = false
  special = false
  number  = false
}

module "project" {
  source                         = "../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = random_string.random_string.result
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services                       = []
}

resource "google_compute_subnetwork" "subnetwork" {
  project       = module.project.project_id
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "northamerica-northeast1"
  network       = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {
  project                 = module.project.project_id
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_resource_policy" "resource_policy" {
  name    = "na-policy"
  region  = "northamerica-northeast1"
  project = module.project.project_id
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}

module "virtual_machine" {
  source = "../"

  project             = module.project.project_id
  vm_zone             = "northamerica-northeast1-a"
  image               = "centos-8"
  image_location      = "centos-cloud"
  user_defined_string = "foo"
  environment         = "D"
  department_code     = "Sc"
  device_type         = "FWL"

  service_account_email_address        = null
  compute_resource_policy              = google_compute_resource_policy.resource_policy.name
  compute_resource_policy_non_bootdisk = google_compute_resource_policy.resource_policy.name

  network_interfaces = [
    {
      id                 = 0
      subnetwork         = google_compute_subnetwork.subnetwork.name
      subnetwork_project = module.project.project_id
    }
  ]

  # disks is optional and can have many maps in the list, a disk will be created for each map and attached to the VM
  disks = [
    {
      id   = 1
      size = 20
      type = "pd-ssd"
    },
    {
      id   = 2
      size = 90
      type = "pd-ssd"
    }
  ]
}