/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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