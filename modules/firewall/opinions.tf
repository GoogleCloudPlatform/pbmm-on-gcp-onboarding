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


# GCP has implicit rule in network where all egress is allowed
# override with this high-priority rule
resource "google_compute_firewall" "deny-all-egress" {
  name        = module.deny_all_egress_name.result
  description = "Allow ingress with a zone"
  network     = var.network
  project     = var.project_id
  direction   = "EGRESS"
  priority    = 65534

  deny {
    protocol = "all"
  }
}

# enable for on-premise connectivity where access can from from interconnect or VPN
resource "google_compute_firewall" "allow-internal" {
  count         = var.internal_ranges_enabled == true && length(var.internal_allow) > 0 ? 1 : 0
  name          = module.allow_internal_name.result
  description   = "Allow ingress traffic from internal IP ranges"
  network       = var.network
  project       = var.project_id
  source_ranges = var.internal_ranges
  target_tags   = var.internal_target_tags

  dynamic "allow" {
    for_each = [for rule in var.internal_allow :
      {
        protocol = lookup(rule, "protocol", null)
        ports    = lookup(rule, "ports", null)
      }
    ]
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}

resource "google_compute_firewall" "allow-admins" {
  count         = var.admin_ranges_enabled == true ? 1 : 0
  name          = module.allow_admins_name.result
  description   = "Access from the admin subnet to all subnets"
  network       = var.network
  project       = var.project_id
  source_ranges = var.admin_ranges

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
}
