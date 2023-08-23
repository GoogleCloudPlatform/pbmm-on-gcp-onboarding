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


###############################################################################
#                        Production Network                                   #
###############################################################################


# artifact inventory
# nonprod private zone
# prod private zone
# prod to prem forwarding zone
# nonprod to prod peering zone

#- add 2nd set of interconnects off non-prod - in #289
#- discuss only vpn and no peering between prod/non-prod if required - as bringing a GCP managed service with underlying IaaS peering will turn the 3 hop nprod-prod-prem into a 4 hop transitive peering network - and break the routing
#- add non-prod private zone
#- add prod private zone
#- add non-prod to prod peering zone - (temporary peering to test routing)
#- add prod to prem forwarding - (prod is the only dns route to prem even though interconnects are on both prod and non-prod)

resource "random_id" "project_suffix" {
  byte_length = 2
}

module "private_zone" {
  source      = "../../modules/dns-zone"
  project_id  = module.net-host-prj.project_id
  type        = "private"
  name        = var.private_zone_name
  domain      = var.private_zone_domain
  labels      = var.labels
  description = "Prod Private Zone"

  # VPCs attached to this zone
  # https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest
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
  ]
}

module "forwarding_zone" {
  source      = "../../modules/dns-zone"
  project_id  = module.net-host-prj.project_id #module.project.project_id
  type        = "forwarding"
  name        = var.forwarding_zone_name
  domain      = var.forwarding_zone_domain
  labels      = var.labels
  description = "Prod Forwarding Zone"

  # VPCs attached to this zone
  # https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest
  # "https://www.googleapis.com/compute/v1/projects/my-project/global/networks/my-vpc"
  #private_visibility_config_networks = var.network_self_links
  #private_visibility_config_networks = ["projects/${module.net-host-prj.project_id}/global/networks/${var.prod_host_net.networks[0].network_self_link}"]
  #private_visibility_config_networks = ["projects/${module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name]}"]
  private_visibility_config_networks = ["projects/${module.net-host-prj.project_id}/global/networks/${module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name]}"]

  target_name_server_addresses = [
    {
      ipv4_address    = var.prod_dns.prod_forward_zone_ipv4_address_1,  #"8.8.8.8",
      forwarding_path = "default"
    },
    {
      ipv4_address    = var.prod_dns.prod_forward_zone_ipv4_address_2#"8.8.4.4",
      forwarding_path = "default"
    }
  ]
}

/*module "public_zone" {
  source      = "../../modules/dns-zone"
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
}*/
