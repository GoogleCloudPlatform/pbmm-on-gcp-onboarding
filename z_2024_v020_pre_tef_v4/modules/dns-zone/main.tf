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


resource "google_dns_managed_zone" "peering" {
  count         = var.type == "peering" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }

  peering_config {
    target_network {
      network_url = var.target_network
    }
  }
}

resource "google_dns_managed_zone" "forwarding" {
  count         = var.type == "forwarding" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) == 0 ? [] : [""]
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }

  dynamic "forwarding_config" {
    for_each = length(var.target_name_server_addresses) == 0 ? [] : [""]
    content {
      dynamic "target_name_servers" {
        for_each = var.target_name_server_addresses
        content {
          ipv4_address    = target_name_servers.value.ipv4_address
          forwarding_path = target_name_servers.value.forwarding_path
        }
      }
    }
  }
}

resource "google_dns_managed_zone" "private" {
  count         = var.type == "private" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) == 0 ? [] : [""]
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}

resource "google_dns_managed_zone" "public" {
  provider      = google-beta
  count         = var.type == "public" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "public"
  force_destroy = var.force_destroy

  dynamic "dnssec_config" {
    for_each = var.dnssec_config == {} ? [] : [var.dnssec_config]
    iterator = config
    content {
      kind          = lookup(config.value, "kind", "dns#managedZoneDnsSecConfig")
      non_existence = lookup(config.value, "non_existence", "nsec3")
      state         = lookup(config.value, "state", "off")

      default_key_specs {
        algorithm  = lookup(var.default_key_specs_key, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_key, "key_length", 2048)
        key_type   = lookup(var.default_key_specs_key, "key_type", "keySigning")
        kind       = lookup(var.default_key_specs_key, "kind", "dns#dnsKeySpec")
      }
      default_key_specs {
        algorithm  = lookup(var.default_key_specs_zone, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_zone, "key_length", 1024)
        key_type   = lookup(var.default_key_specs_zone, "key_type", "zoneSigning")
        kind       = lookup(var.default_key_specs_zone, "kind", "dns#dnsKeySpec")
      }
    }
  }

}

resource "google_dns_record_set" "cloud-static-records" {
  project      = var.project_id
  managed_zone = var.name

  for_each = { for record in var.recordsets : join("/", [record.name, record.type]) => record }
  name = (
    each.value.name != "" ?
    "${each.value.name}.${var.domain}" :
    var.domain
  )
  type = each.value.type
  ttl  = each.value.ttl

  rrdatas = each.value.records

  depends_on = [
    google_dns_managed_zone.private,
    google_dns_managed_zone.public,
  ]
}

/*
# commented during https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/286
resource "google_dns_policy" "dns-policy" {
  count         = var.enable_inbound_forwarding ? 1 : 0
  project                   = var.project_id
  name                      = "dns-policy"
  enable_inbound_forwarding = var.enable_inbound_forwarding

  enable_logging = var.enable_logging

  networks {
    network_url = var.dns_policy_network
  }
}*/
