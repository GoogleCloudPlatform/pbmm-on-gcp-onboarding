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


resource "google_compute_router" "router" {
  name    = "unittest-nat-router"
  project = module.project.project_id
  region  = var.region
  network = google_compute_network.transit_network.name
}

resource "google_compute_router_nat" "main" {
  project                            = module.project.project_id
  region                             = var.region
  name                               = "unittest-transit-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.transit_subnetwork.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
