/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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
