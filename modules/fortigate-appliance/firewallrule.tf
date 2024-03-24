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

# Firewall Rule Public Ingress
resource "google_compute_firewall" "allow_fgt_public_ingress" {
  project  = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name     = "allow-fgt-public-ingress-${random_string.random_name_post.result}"
  network  = data.google_compute_subnetwork.subnetworks[var.public_port].network
  priority = 110

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  target_tags   = ["allow-fgt-public-ingress"]
}

# Firewall Rule External Ingress
resource "google_compute_firewall" "allow_fgt_external_ingress" {
  project  = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name     = "allow-fgt-external-ingress-${random_string.random_name_post.result}"
  network  = data.google_compute_subnetwork.subnetworks[var.public_port].network
  priority = 100

  allow {
    protocol = "all"
  }

  source_ranges = ["172.16.0.0/16", "10.0.0.0/8"] # From any intranet networks
  target_tags   = ["allow-fgt-external-ingress"]
}

# Firewall Rule Public Health Check Ingress
resource "google_compute_firewall" "allow_ftg_healthchecks_ingress" {
  project  = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name     = "allow-ftg-healthchecks-ingress-${random_string.random_name_post.result}"
  network  = data.google_compute_subnetwork.subnetworks[var.public_port].network
  priority = 100

  allow {
    protocol = "tcp"
    ports    = [var.lb_probe_port]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["allow-ftg-healthchecks-ingress"]
}

# Firewall Rule Internal Ingress
resource "google_compute_firewall" "allow_ftg_internal_ingress" {
  project  = data.google_compute_subnetwork.subnetworks[var.internal_port].project
  name     = "allow-ftg-internal-ingress-${random_string.random_name_post.result}"
  network  = data.google_compute_subnetwork.subnetworks[var.internal_port].network
  priority = 100

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  target_tags   = ["allow-ftg-internal-ingress"]
}

# Firewall Rule HA SYNC Ingress
resource "google_compute_firewall" "allow_ftg_sync_ingress" {
  project  = data.google_compute_subnetwork.subnetworks[var.ha_port].project
  name     = "allow-ftg-sync-ingress-${random_string.random_name_post.result}"
  network  = data.google_compute_subnetwork.subnetworks[var.ha_port].network
  priority = 100

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  target_tags   = ["allow-ftg-sync-ingress"]
}

# Firewall Rule HA MGMT Ingress
resource "google_compute_firewall" "allow_ftg_mgmt_ingress" {
  project  = data.google_compute_subnetwork.subnetworks[var.mgmt_port].project
  name     = "allow-ftg-mgmt-ingress-${random_string.random_name_post.result}"
  network  = data.google_compute_subnetwork.subnetworks[var.mgmt_port].network
  priority = 100

  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  target_tags   = ["allow-ftg-mgmt-ingress"]
}

# Firewall Rule Allow FTG Internet Egress
resource "google_compute_firewall" "allow_ftg_internet_egress" {
  project            = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name               = "allow-ftg-internet-egress-${random_string.random_name_post.result}"
  network            = data.google_compute_subnetwork.subnetworks[var.public_port].network
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  priority           = 100

  allow {
    protocol = "all"
  }
  target_tags = ["allow-ftg-internet-egress"]
}

# Firewall Rule Allow Public Internet Egress
resource "google_compute_firewall" "allow_public_internet_egress" {
  project            = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name               = "allow-public-internet-egress-${random_string.random_name_post.result}"
  network            = data.google_compute_subnetwork.subnetworks[var.public_port].network
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  priority           = 50000

  allow {
    protocol = "all"
  }
}

# Firewall Rule Allow Internal Internet Egress
resource "google_compute_firewall" "allow_internal_internet_egress" {
  project            = data.google_compute_subnetwork.subnetworks[var.public_port].project
  name               = "allow-internal-internet-egress-${random_string.random_name_post.result}"
  network            = data.google_compute_subnetwork.subnetworks[var.public_port].network
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/1", "128.0.0.0/1"]
  priority           = 50000

  allow {
    protocol = "all"
  }
}
