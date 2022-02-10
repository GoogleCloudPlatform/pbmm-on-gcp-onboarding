/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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
