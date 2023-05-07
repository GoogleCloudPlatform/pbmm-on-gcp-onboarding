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
