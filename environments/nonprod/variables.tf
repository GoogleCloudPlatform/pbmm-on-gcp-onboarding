/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/



variable "tf_service_account_email" {
  type        = string
  description = "E-mail of the terraform deployer service account"
  default     = null
}

variable "nonprod_host_net" {
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

variable "nonprod_firewall" {
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

variable "nonprod_vpc_svc_ctl" {
  type = object({
    regular_service_perimeter      = map(object({
      description                  = optional(string)
      perimeter_name               = string
      restricted_services          = optional(list(string))
      resources                    = optional(list(string))
      resources_by_numbers         = optional(list(string))
      access_levels                = optional(list(string))
      restricted_services_dry_run  = optional(list(string))
      resources_dry_run            = optional(list(string))
      resources_dry_run_by_numbers = optional(list(string))
      access_levels_dry_run        = optional(list(string))
      vpc_accessible_services = optional(object({
        enable_restriction = bool,
        allowed_services   = list(string),
      }))
      dry_run  = optional(bool)
      live_run = optional(bool)
    }))
    bridge_service_perimeter = map(object({
      description                  = optional(string)
      perimeter_name               = string
      resources                    = optional(list(string))
      resources_by_numbers         = optional(list(string))
      resources_dry_run            = optional(list(string))
      resources_dry_run_by_numbers = optional(list(string))
      dry_run                      = optional(bool)
      live_run                     = optional(bool)
    }))
  })
  description = "Map of service perimeter controls. Can include regular service perimeters or bridge service perimeters"
  default = {regular_service_perimeter = {}, bridge_service_perimeter = {}}
}
