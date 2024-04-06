/**
 * Copyright 2023 Google LLC
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

# Workload route to ILBnH for external network
resource "google_compute_route" "external_default" {
  project      = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name         = "to-workload-via-ilbnh-${random_string.random_name_post.result}"
  description  = "Route traffic to protected workloads via ILBnH"
  dest_range   = var.workload_ip_cidr_range
  network      = data.google_compute_subnetwork.subnetworks[var.public_port].network
  next_hop_ilb = google_compute_forwarding_rule.external_ilbnh.ip_address
  priority     = 50000
  depends_on = [
    google_compute_forwarding_rule.external_ilbnh
  ]
}

# Default route to ILBnH for internal network
resource "google_compute_route" "internal_default" {
  project      = data.google_compute_subnetwork.subnetworks[var.internal_port].project
  name         = "internal-ilbnh-${random_string.random_name_post.result}"
  description  = "Internal route to ILBnH"
  dest_range   = "0.0.0.0/0"
  network      = data.google_compute_subnetwork.subnetworks[var.internal_port].network
  next_hop_ilb = google_compute_forwarding_rule.internal_ilbnh.ip_address
  priority     = 50000
  depends_on = [
    google_compute_forwarding_rule.internal_ilbnh
  ]
}

# Router
resource "google_compute_router" "public_router" {
  project = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name    = "ftg-public-router-${random_string.random_name_post.result}"
  region  = var.region
  network = data.google_compute_subnetwork.subnetworks[var.public_port].network
}

# NAT
resource "google_compute_router_nat" "public_nat" {
  project                            = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name                               = "ftg-router-nat-${random_string.random_name_post.result}"
  router                             = google_compute_router.public_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
