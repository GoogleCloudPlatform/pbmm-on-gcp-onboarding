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

# External Pass-Through Network Load Balancer

resource "google_compute_forwarding_rule" "external_passthrough_nlb" {
  project    = var.project
  name       = "external-passthrough-nlb-${random_string.random_name_post.result}"
  region     = var.region
  ip_address = google_compute_address.cluster_sip.address

  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_pool.external_passthrough_nlb_targetpool.self_link
}

resource "google_compute_target_pool" "external_passthrough_nlb_targetpool" {
  project          = var.project
  name             = "fgt-targetpool-${random_string.random_name_post.result}"
  region           = var.region
  session_affinity = "CLIENT_IP"

  instances = [for key, instance in google_compute_instance_from_template.fgtvm_instances : instance.self_link]
  health_checks = [
    google_compute_http_health_check.external_passthrough_nlb_healthcheck.name
  ]
}

resource "google_compute_http_health_check" "external_passthrough_nlb_healthcheck" {
  project             = var.project
  name                = "health-check-backend-${random_string.random_name_post.result}"
  check_interval_sec  = 3
  timeout_sec         = 2
  unhealthy_threshold = 3
  port                = var.lb_probe_port
}

# Unmanaged Instance Groups for FTG-VM Instances
resource "google_compute_instance_group" "fgtvm_umigs" {
  for_each  = local.instances
  name      = module.unmanaged_instance_group[each.key].result
  project   = var.project
  zone      = each.value.zone
  instances = [google_compute_instance_from_template.fgtvm_instances[each.key].self_link]
}

# Common ilbnh health check
resource "google_compute_health_check" "ilbnh_common" {
  project            = var.project
  name               = "ilbnh-common-healthcheck-${random_string.random_name_post.result}"
  check_interval_sec = 3
  timeout_sec        = 2
  tcp_health_check {
    port = var.lb_probe_port
  }
}

# Internal Pass-Through Network Load Balancer as Next Hop for intenral network

resource "google_compute_address" "internal_ilbnh_address" {
  project      = var.project
  name         = "internal-ilbnh-address-${random_string.random_name_post.result}"
  subnetwork   = data.google_compute_subnetwork.subnetworks[var.internal_port].self_link
  address_type = "INTERNAL"
  address      = cidrhost(data.google_compute_subnetwork.subnetworks[var.internal_port].ip_cidr_range, 5)
  region       = var.region
  lifecycle {
    ignore_changes = all
  }
}

resource "google_compute_forwarding_rule" "internal_ilbnh" {
  project    = var.project
  name       = "internal-ilbnh-${random_string.random_name_post.result}"
  region     = var.region
  ip_address = google_compute_address.internal_ilbnh_address.address

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal_ilbnh_backend.self_link
  all_ports             = true
  network               = data.google_compute_subnetwork.subnetworks[var.internal_port].network
  subnetwork            = data.google_compute_subnetwork.subnetworks[var.internal_port].self_link
}

resource "google_compute_region_backend_service" "internal_ilbnh_backend" {
  project                         = var.project
  name                            = "internal-ilbnh-backend-${random_string.random_name_post.result}"
  region                          = var.region
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
  network                         = data.google_compute_subnetwork.subnetworks[var.internal_port].network

  dynamic "backend" {
    for_each = google_compute_instance_group.fgtvm_umigs
    content {
      group = backend.value.self_link
    }
  }

  health_checks = [
    google_compute_health_check.ilbnh_common.self_link
  ]
}

# Internal Pass-Through Network Load Balancer as Next Hop for external network

resource "google_compute_address" "external_ilbnh_address" {
  project      = var.project
  name         = "external-ilbnh-address-${random_string.random_name_post.result}"
  subnetwork   = data.google_compute_subnetwork.subnetworks[var.public_port].self_link
  address_type = "INTERNAL"
  address      = cidrhost(data.google_compute_subnetwork.subnetworks[var.public_port].ip_cidr_range, 5)
  region       = var.region
  lifecycle {
    ignore_changes = all
  }
}

resource "google_compute_forwarding_rule" "external_ilbnh" {
  project    = var.project
  name       = "external-ilbnh-${random_string.random_name_post.result}"
  region     = var.region
  ip_address = google_compute_address.external_ilbnh_address.address

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.external_ilbnh_backend.self_link
  all_ports             = true
  network               = data.google_compute_subnetwork.subnetworks[var.public_port].network
  subnetwork            = data.google_compute_subnetwork.subnetworks[var.public_port].self_link
}

resource "google_compute_region_backend_service" "external_ilbnh_backend" {
  project                         = var.project
  name                            = "external-ilbnh-backend-${random_string.random_name_post.result}"
  region                          = var.region
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
  network                         = data.google_compute_subnetwork.subnetworks[var.public_port].network

  dynamic "backend" {
    for_each = google_compute_instance_group.fgtvm_umigs
    content {
      group = backend.value.self_link
    }
  }

  health_checks = [
    google_compute_health_check.ilbnh_common.self_link
  ]
}
