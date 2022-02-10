/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  network = var.network_name
  project = var.project_id

  name                     = module.subnet_name.result
  description              = var.description
  region                   = var.subnet_region
  ip_cidr_range            = var.subnet_ip
  private_ip_google_access = var.subnet_private_access

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = var.log_config[*]
    content {
      aggregation_interval = lookup(log_config.value, "aggregation_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(log_config.value, "flow_sampling", 0.5)
      metadata             = lookup(log_config.value, "metadata", "INCLUDE_ALL_METADATA")
    }
  }
}
