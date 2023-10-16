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



variable prod_logging {
        type = object({
  log_sink_name = string
  gcs_sink_name = string
  log_bucket_name = string
  gcs_bucket_name = string
  region1 = string
    })
}

variable prod-interconnect {
        type = object({
  interconnect_router_name = string

  # currently defaulted - uncomment to set
  region1 = string

  preactivate = bool

  region1_vlan1_name = string
  region1_vlan2_name = string
  region1_vlan3_name = string
  region1_vlan4_name = string
  psc_ip = string
    })
}

/*
variable "prod_services_project_iam" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object(
    {
      member  = string
      roles   = list(string)
      project = optional(string)
    }
  ))
  default = []
}
*/
variable "prod_vpc_svc_ctl" {
  type        = map(any)
  description = "Map of service perimeter controls. Can include regular service perimeters or bridge service perimeters"
  default = null
}

variable "prod_workload_net" {
  type = object({
    user_defined_string            = string
    additional_user_defined_string = optional(string)
    billing_account                = string
    services                       = optional(list(string))
    labels                         = optional(object({}))
    networks = list(object({
      network_name                           = string
      description                            = optional(string)
      routing_mode                           = optional(string)
      shared_vpc_host                        = optional(bool)
      auto_create_subnetworks                = optional(bool)
      delete_default_internet_gateway_routes = optional(bool)
      peer_project                           = optional(string)
      peer_network                           = optional(string)
      export_peer_custom_routes              = optional(bool)
      export_local_custom_routes             = optional(bool)
      mtu                                    = optional(number)
      subnets = list(object({
        subnet_name           = string
        description           = optional(string)
        subnet_private_access = optional(bool)
        subnet_region         = optional(string)
        subnet_ip             = string
        secondary_ranges = optional(list(object({
          range_name    = string
          ip_cidr_range = string
        })))
        log_config = optional(object({
          aggregation_interval = optional(string)
          flow_sampling        = optional(number)
          metadata             = optional(string)
        }))
      }))
      routes = optional(list(object({
        route_name                        = string
        description                       = optional(string)
        destination_range                 = string
        next_hop_default_internet_gateway = optional(bool)
        next_hop_gateway                  = optional(string)
        next_hop_ip                       = optional(string)
        next_hop_instance                 = optional(string)
        next_hop_instance_zone            = optional(string)
        next_hop_vpn_tunnel               = optional(string)
        priority                          = optional(number)
        tags                              = optional(list(string))
      })))
      routers = optional(list(object({
        router_name = string
        description = optional(string)
        region      = optional(string)
        bgp = optional(object({
          asn               = number
          advertise_mode    = optional(string)
          advertised_groups = optional(list(string))
          advertised_ip_ranges = optional(list(object({
            range       = string
            description = optional(string)
          })))
        }))
      })))
      vpn_config = optional(list(object({
        ha_vpn_name     = string
        ext_vpn_name    = optional(string)
        vpn_tunnel_name = string
        peer_info = list(object({
          peer_asn        = string
          peer_ip_address = string
        }))
        peer_external_gateway = object({
          redundancy_type = string
          interfaces = list(object({
            id              = string
            router_ip_range = string
            ip_address      = string
          }))
        })
        tunnels = object({
          bgp_session_range               = string
          ike_version                     = number
          vpn_gateway_interface           = number
          peer_external_gateway_interface = number
        })
      })))
    }))

  })
  description = "Input values for the client workload service project"
}

variable "prod_host_net" {
  type = object({
    user_defined_string            = string
    additional_user_defined_string = optional(string)
    billing_account                = string
    services                       = optional(list(string))
    labels                         = optional(object({}))
    networks = list(object({
      network_name                           = string
      description                            = optional(string)
      routing_mode                           = optional(string)
      shared_vpc_host                        = optional(bool)
      auto_create_subnetworks                = optional(bool)
      delete_default_internet_gateway_routes = optional(bool)
      peer_project                           = optional(string)
      peer_network                           = optional(string)
      export_peer_custom_routes              = optional(bool)
      export_local_custom_routes             = optional(bool)
      mtu                                    = optional(number)
      subnets = list(object({
        subnet_name           = string
        description           = optional(string)
        subnet_private_access = optional(bool)
        subnet_region         = optional(string)
        subnet_ip             = string
        secondary_ranges = optional(list(object({
          range_name    = string
          ip_cidr_range = string
        })))
        log_config = optional(object({
          aggregation_interval = optional(string)
          flow_sampling        = optional(number)
          metadata             = optional(string)
        }))
      }))
      routes = optional(list(object({
        route_name                        = string
        description                       = optional(string)
        destination_range                 = string
        next_hop_default_internet_gateway = optional(bool)
        next_hop_gateway                  = optional(string)
        next_hop_ip                       = optional(string)
        next_hop_instance                 = optional(string)
        next_hop_instance_zone            = optional(string)
        next_hop_vpn_tunnel               = optional(string)
        priority                          = optional(number)
        tags                              = optional(list(string))
      })))
      routers = optional(list(object({
        router_name = string
        description = optional(string)
        region      = optional(string)
        bgp = optional(object({
          asn               = number
          advertise_mode    = optional(string)
          advertised_groups = optional(list(string))
          advertised_ip_ranges = optional(list(object({
            range       = string
            description = optional(string)
          })))
        }))
      })))
      vpn_config = optional(list(object({
        ha_vpn_name     = string
        ext_vpn_name    = optional(string)
        vpn_tunnel_name = string
        peer_info = list(object({
          peer_asn        = string
          peer_ip_address = string
        }))
        peer_external_gateway = object({
          redundancy_type = string
          interfaces = list(object({
            id              = string
            router_ip_range = string
            ip_address      = string
          }))
        })
        tunnels = object({
          bgp_session_range               = string
          ike_version                     = number
          vpn_gateway_interface           = number
          peer_external_gateway_interface = number
        })
      })))
    }))

  })
  description = "Input values for the network host project"
}

variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}

variable "prod_firewall" {
  type = object({
    custom_rules = map(object({
      description          = string
      direction            = string
      action               = string # (allow|deny)
      ranges               = list(string)
      sources              = list(string)
      targets              = list(string)
      use_service_accounts = bool
      rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      extra_attributes = map(string)
    }))
  })
  description = "(optional) describe your variable"
}

/*
variable "labels" {
  type = object({
    creator                 = optional(string),
    date_created            = optional(string),
    date_modified           = optional(string),
    title                   = optional(string),
    department              = optional(string),
    imt_sector              = optional(string),
    environment             = optional(string),
    service_id              = optional(string),
    application_name        = optional(string),
    business_contact        = optional(string),
    technical_contact       = optional(string),
    general_ledger_account  = optional(string),
    cost_center             = optional(string),
    internal_order          = optional(string),
    sos_id                  = optional(string),
    stra_id                 = optional(string),
    security_classification = optional(string),
    criticality             = optional(string),
    hours_of_operation      = optional(string),
    project_code            = optional(string)
  })
}*/


# 286 private dns


variable prod_dns {
        type = object({
  # currently defaulted - uncomment to set
  region1 = string
  parent = string

  prod_forward_zone_ipv4_address_1 = string
  prod_forward_zone_ipv4_address_2 = string
    })
}

/*
variable "parent" {
  description = "folder/#### or organizations/### to place the project into"
  type        = string
}*/

/*variable "billing_account" {
  description = "billing account ID"
  type        = string
}*/

variable "owner" {
  type        = string
  description = "Owner of the project"
  default     = "Ga"
}

variable "environment" {
  type        = string
  description = "P = Prod, N = NonProd, S = SandBox, etc."
  default     = "P"
}

variable "department_code" {
  type        = string
  description = "The Department Code Used for Naming Purposes."
  default     = "Lz"
}

variable "location" {
  type        = string
  description = "location for naming purposes."
  default     = "northamerica-northeast1"
}

variable "network_self_links" {
  description = "Self link of the network that will be allowed to query the zone."
  default     = []
}

variable "private_zone_name" {
  description = "Private DNS zone name."
  default     = "private-local"
}

variable "private_zone_domain" {
  description = "Private Zone domain."
  default     = "private.local."
}

variable "public_zone_name" {
  description = "DNS zone name"
  default     = "gov-public-org"
}

variable "public_zone_domain" {
  description = "Zone domain"
  default     = "gov.public.org."
}

variable "forwarding_zone_name" {
  description = "Forwarding DNS zone name"
  default     = "dns-local"
}

variable "forwarding_zone_domain" {
  description = "Forwarding Zone domain"
  default     = "dns.local."
}

variable "labels" {
  type        = map(any)
  description = "Labels for the ManagedZone"
  default = {
    owner   = "foo"
    version = "bar"
  }
}