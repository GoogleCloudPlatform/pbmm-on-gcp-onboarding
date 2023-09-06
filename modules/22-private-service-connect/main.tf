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

locals {
  dns_code        = var.dns_code != "" ? "${var.dns_code}-" : ""
  googleapis_url  = var.forwarding_rule_target == "vpc-sc" ? "restricted.googleapis.com." : "private.googleapis.com."
  recordsets_name = split(".", local.googleapis_url)[0]
}

resource "google_compute_global_address" "private_service_connect" {
  provider     = google-beta
  project      = var.project_id
  name         = var.private_service_connect_name
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = var.network_self_link
  address      = var.private_service_connect_ip
}

/*
# switch from the global google_compute_global_forwarding_rule to google_compute_forwarding_rule 
# https://github.com/hashicorp/terraform-provider-google-beta/blob/main/website/docs/r/compute_forwarding_rule.html.markdown
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule.html
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule.html
resource "google_compute_forwarding_rule" "forwarding_rule_private_service_connect" {
  name                  = var.forwarding_rule_name
  target                = var.forwarding_rule_target
  provider              = google-beta
  region                = var.region #"europe-west1"
  #depends_on            = [google_compute_subnetwork.proxy_subnet]
  #ip_protocol           = "TCP"
  load_balancing_scheme = ""#"INTERNAL_MANAGED"
  ip_address            = google_compute_global_address.private_service_connect.id
  project               = var.project_id
  #port_range            = "80"
  #target                = google_compute_region_target_http_proxy.default.id
  network               = var.network_self_link
  #subnetwork             = var.subnetwork_self_link
  #network_tier          = "PREMIUM"
}*/

resource "google_compute_global_forwarding_rule" "forwarding_rule_private_service_connect" {
  provider              = google-beta
  project               = var.project_id
  name                  = var.forwarding_rule_name
  target                = var.forwarding_rule_target
  network               = var.network_self_link
  ip_address            = google_compute_global_address.private_service_connect.id
  load_balancing_scheme = ""
}

# will auto associate this DNS ingress policy - with the generated dns-forwarding ip created during PSC creation
resource "google_dns_policy" "default_policy" {
  provider                  = google-beta
  project                   = var.project_id
  # lc and only - (no spaces)
  name                      = "psc-ingress-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url =  var.network_self_link
  }
}

