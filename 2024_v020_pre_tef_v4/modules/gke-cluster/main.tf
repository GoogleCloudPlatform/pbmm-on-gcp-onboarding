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

data "google_container_engine_versions" "location" {
  location = var.location
  project  = var.project
}

resource "google_container_cluster" "cluster" {
  # provider = google-beta

  name        = local.cluster_name
  description = var.description

  project        = var.project
  location       = var.location
  node_locations = var.node_locations
  network        = var.network
  subnetwork     = var.subnetwork

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
  min_master_version = local.kubernetes_version

  enable_legacy_abac = var.enable_legacy_abac

  remove_default_node_pool = true

  initial_node_count = var.initial_node_count

  node_config {
    service_account = var.alternative_default_service_account
    tags            = var.default_node_tags
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = var.disable_public_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = !var.enable_network_policy
    }
  }

  network_policy {
    enabled = var.enable_network_policy

    # Tigera (Calico Felix) is the only provider
    provider = var.enable_network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  # master_auth {
  #   username = var.basic_auth_username
  #   password = var.basic_auth_password
  # }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  lifecycle {
    ignore_changes = all
  }

  dynamic "authenticator_groups_config" {
    for_each = [
      for x in [var.gsuite_domain_name] : x if var.gsuite_domain_name != null
    ]

    content {
      security_group = "gke-security-groups@${authenticator_groups_config.value}"
    }
  }

  dynamic "database_encryption" {
    for_each = [
      for x in [var.secrets_encryption_kms_key] : x if var.secrets_encryption_kms_key != null
    ]

    content {
      state    = "ENCRYPTED"
      key_name = database_encryption.value
    }
  }

  dynamic "workload_identity_config" {
    for_each = local.workload_identity_config

    content {
      identity_namespace = workload_identity_config.value.identity_namespace
    }
  }

  resource_labels = var.resource_labels

}

resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools

  # provider = google-beta

  name           = each.value.name
  project        = var.project
  location       = var.location
  node_locations = each.value.node_locations == null ? var.node_locations : each.value.node_locations
  cluster        = google_container_cluster.cluster.name

  initial_node_count = each.value.initial_node_count

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    # image_type   = "COS"
    machine_type = each.value.machine_type

    preemptible = each.value.preemptible

    service_account = each.value.service_account

    # boot_disk_kms_key = each.value.boot_disk_kms_key

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    tags   = each.value.tags
    labels = each.value.labels
    taint  = each.value.taint
  }

  lifecycle {
    ignore_changes = all
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
