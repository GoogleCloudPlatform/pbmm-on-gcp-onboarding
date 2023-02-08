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



resource "random_id" "project_suffix" {
  byte_length = 2
}

module "project" {
  source                         = "../../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = "TestDnsZone"
  additional_user_defined_string = random_id.project_suffix.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services = [
    "dns.googleapis.com"
  ]
}

module "private_zone" {
  source      = "../"
  project_id  = module.project.project_id
  type        = "private"
  name        = var.private_zone_name
  domain      = var.private_zone_domain
  labels      = var.labels
  description = "Example Private Zone"

  private_visibility_config_networks = var.network_self_links

  recordsets = [
    {
      name = "ns"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = "localhost"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = ""
      type = "MX"
      ttl  = 300
      records = [
        "1 mailhost1.example.com.",
      ]
    },
    {
      name = ""
      type = "TXT"
      ttl  = 300
      records = [
        "\"My Text Verification Record\"",
      ]
    },
  ]
}

module "public_zone" {
  source      = "../"
  project_id  = module.project.project_id
  type        = "public"
  name        = var.public_zone_name
  domain      = var.public_zone_domain
  labels      = var.labels
  description = "Example Public Zone"

  dnssec_config = {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "off"
  }

  private_visibility_config_networks = var.network_self_links

  recordsets = [
    {
      name = "ns"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = "localhost"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = ""
      type = "MX"
      ttl  = 300
      records = [
        "1 mailbox1.localhost.",
      ]
    },
    {
      name = ""
      type = "TXT"
      ttl  = 300
      records = [
        "\"Example TXT Verification Record\"",
      ]
    },
  ]
}

module "forwarding_zone" {
  source      = "../"
  project_id  = module.project.project_id
  type        = "forwarding"
  name        = var.forwarding_zone_name
  domain      = var.forwarding_zone_domain
  labels      = var.labels
  description = "Example Forwarding Zone"

  private_visibility_config_networks = var.network_self_links
  target_name_server_addresses = [
    {
      ipv4_address    = "8.8.8.8",
      forwarding_path = "default"
    },
    {
      ipv4_address    = "8.8.4.4",
      forwarding_path = "default"
    }
  ]
}