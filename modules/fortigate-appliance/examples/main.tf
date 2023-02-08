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
  source                         = "../../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = random_string.random_string.result
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services = [
    "container.googleapis.com"
  ]
}

# Transit
resource "google_compute_network" "transit_network" {
  project                 = module.project.project_id
  name                    = "transit-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "transit_subnetwork" {
  project       = module.project.project_id
  name          = "transit-subnetwork"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region
  network       = google_compute_network.transit_network.id
}

# fortigate
resource "google_compute_network" "fortigate_ha_network" {
  project                 = module.project.project_id
  name                    = "fortigate-ha-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "fortigate_ha_subnetwork" {
  project       = module.project.project_id
  name          = "ha-subnetwork"
  ip_cidr_range = "10.2.0.0/24"
  region        = "northamerica-northeast1"
  network       = google_compute_network.fortigate_ha_network.id
}

# Internal
resource "google_compute_network" "internal_network" {
  project                 = module.project.project_id
  name                    = "internal-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "internal_subnetwork" {
  project       = module.project.project_id
  name          = "internal-subnetwork"
  ip_cidr_range = "10.3.0.0/24"
  region        = "northamerica-northeast1"
  network       = google_compute_network.internal_network.id
}

# mirror
resource "google_compute_network" "mirror_network" {
  project                 = module.project.project_id
  name                    = "mirror-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mirror_subnetwork" {
  project       = module.project.project_id
  name          = "mirror-subnetwork"
  ip_cidr_range = "10.4.0.0/24"
  region        = "northamerica-northeast1"
  network       = google_compute_network.mirror_network.id
}

# peer mirror and internal for traffic mirroring
resource "google_compute_network_peering" "internal-mirror" {
  name         = "internal-mirror"
  network      = google_compute_network.internal_network.id
  peer_network = google_compute_network.mirror_network.id
}

resource "google_compute_network_peering" "mirror-internal" {
  name         = "mirror-internal"
  network      = google_compute_network.mirror_network.id
  peer_network = google_compute_network.internal_network.id
}

module "fortigates" {
  source = "../"

  project             = module.project.project_id
  zone_1              = var.zone_1
  user_defined_string = var.user_defined_string
  environment         = var.environment
  department_code     = var.department_code
  owner               = var.owner

  network_tags = local.network_tags

  network_ports = {
    port1 = {
      port_name  = "port1-transit-port"
      project    = module.project.project_id
      subnetwork = google_compute_subnetwork.transit_subnetwork.name
    },
    port2 = {
      port_name  = "port2-ha-port"
      project    = module.project.project_id
      subnetwork = google_compute_subnetwork.fortigate_ha_subnetwork.name
    },
    port3 = {
      port_name  = "port3-internal-port"
      project    = module.project.project_id
      subnetwork = google_compute_subnetwork.internal_subnetwork.name
    },
    port4 = {
      port_name  = "port4-mirror-port"
      project    = module.project.project_id
      subnetwork = google_compute_subnetwork.mirror_subnetwork.name
    }
  }
  depends_on = [
    google_compute_network_peering.internal-mirror,
    google_compute_network_peering.mirror-internal,
  ]
}