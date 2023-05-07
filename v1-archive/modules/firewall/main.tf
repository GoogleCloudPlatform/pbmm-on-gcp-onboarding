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


resource "google_compute_firewall" "custom" {
  for_each                = var.custom_rules
  name                    = module.custom_rules_names[each.key].result
  description             = each.value.description
  direction               = each.value.direction
  network                 = var.network
  project                 = var.project_id
  # EGRESS does not have a Source range. For EGRESS, there are ONLY Target tags and destination range
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  # Sourced tags are set ONLY when service account is 'false' or Firewall direction is INGRESS
  source_tags            = each.value.use_service_accounts || each.value.direction == "EGRESS" ? null : each.value.sources
  source_service_accounts = each.value.use_service_accounts && each.value.direction == "INGRESS" ? each.value.sources : null
  target_tags             = each.value.use_service_accounts ? null : each.value.targets
  target_service_accounts = each.value.use_service_accounts ? each.value.targets : null
  disabled                = lookup(each.value.extra_attributes, "disabled", false)
  priority                = lookup(each.value.extra_attributes, "priority", 1000)

  dynamic "log_config" {
    for_each = lookup(each.value.extra_attributes, "flow_logs", false) ? [{
      metadata = lookup(each.value.extra_attributes, "flow_logs_metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      metadata = log_config.value.metadata
    }
  }

  dynamic "allow" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "allow"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }

  dynamic "deny" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "deny"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}

# IAP Rules
resource "google_compute_firewall" "bastion_rule" {
  count         = var.enable_bastion_ports ? 1 : 0
  name          = module.bastion_rule_name.result
  description   = "Rule to allow conections to ports 22 and 3389 via IAP"
  network       = var.network
  project       = var.project_id
  source_ranges = toset(["35.235.240.0/20"])

  allow {
    protocol = "tcp"
    ports    = ["3389", "22"]
  }
}

resource "google_compute_firewall" "custom_iap_rule" {
  for_each      = var.custom_iap_rules
  name          = module.iap_rules_names[each.key].result
  description   = "Rule to allow custom port via IAP"
  network       = var.network
  project       = var.project_id
  source_ranges = toset(["35.235.240.0/20"])

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }
}

