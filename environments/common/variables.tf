/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

variable "org_policies" {
  description = "Optional additional policies"
  type = object(
    {
      directory_customer_id   = optional(list(string))
      policy_boolean          = optional(object({}))
      policy_list             = optional(object({}))
      setDefaultPolicy        = bool
      vmAllowedWithExternalIp = list(string)
      vmAllowedWithIpForward  = list(string)
    }
  )
}

variable "folders" {
  description = "folder/#### or organizations/### to place the project into"
  type = object(
    {
      parent       = string
      names        = list(string)
      subfolders_1 = map(string)
      subfolders_2 = map(string)
    }
  )
}

variable "audit" {
  description = "Values for the audit stream bucket configuration"
  type = object({
    user_defined_string            = string
    additional_user_defined_string = string
    billing_account                = string
    audit_streams = map(object({
      bucket_name          = string
      is_locked            = bool
      bucket_force_destroy = bool
      bucket_storage_class = string
      labels               = map(string)
      sink_name            = string #must be unique across organization
      description          = string
      filter               = string
      retention_period     = number
      bucket_viewer        = string
    }))
    audit_labels = optional(object({}))
  })
}

variable "access_context_manager" {
  description = "The object used for the access level policies."
  type = object(
    {
      policy_name         = string
      policy_id           = string
      access_level        = map(object({}))
      user_defined_string = string
    }
  )
}

variable "audit_project_iam" {
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

variable "folder_iam" {
  description = "List of accounts to grant roles to on a specified folder/########"
  type = list(object({
    member = string
    roles  = list(string)
    folder = optional(string)
    audit_folder_name = string
  }))
  default = []
}
variable "organization_iam" {
  description = "List of accounts to grant roles to with to the organizations/#######"
  type = list(object({
    member       = string
    roles        = list(string)
    organization = optional(string)
  }))
  default = []
}

variable "custom_roles" {
  description = "Map of roles to create"
  type = map(
    object({
      title       = string
      description = string
      role_id     = string
      permissions = list(string)
    })
  )
}

variable "service_accounts" {
  description = "List of service accounts to create and roles to assign to them"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
    project      = optional(string)
  }))
  default = []
}

variable "guardrails" {
  type = object({
    billing_account     = string
    org_id_scan_list    = list(string)
    org_client          = bool
    user_defined_string = string
  })
  description = "GCP guard rails are created using rego based policies in this project"
}

##################################################
#          Perimiter Variables                   #
##################################################
variable "public_perimeter_net" {
  type = object({
    user_defined_string            = string
    additional_user_defined_string = string
    billing_account                = string
    services                       = list(string)
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
          # bgp_session_range               = string
          ike_version           = number
          vpn_gateway_interface = number
          # peer_external_gateway_interface = number
        })
      })))
    }))
  })
}

variable "private_perimeter_net" {
  type = object({
    user_defined_string            = string
    additional_user_defined_string = string
    billing_account                = string
    services                       = list(string)
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
          # bgp_session_range               = string
          ike_version           = number
          vpn_gateway_interface = number
          # peer_external_gateway_interface = number
        })
      })))
    }))
  })
}

variable "ha_perimeter_net" {
  type = object({
    user_defined_string            = string
    additional_user_defined_string = string
    billing_account                = string
    services                       = list(string)
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
          # bgp_session_range               = string
          ike_version           = number
          vpn_gateway_interface = number
          # peer_external_gateway_interface = number
        })
      })))
    }))
  })
}


variable "management_perimeter_net" {
  type = object({
    user_defined_string            = string
    additional_user_defined_string = string
    billing_account                = string
    services                       = list(string)
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
          # bgp_session_range               = string
          ike_version           = number
          vpn_gateway_interface = number
          # peer_external_gateway_interface = number
        })
      })))
    }))
  })
}

variable "prod_public_perimeter_firewall" {
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
      extra_attributes = object({
        disabled = bool
        priority = number
        flow_logs = bool
      })
    }))
  })
  description = "(optional) describe your variable"
}

variable "prod_private_perimeter_firewall" {
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

# keep fortigate config off until finalized a cloud build issue - see 
# https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/pull/43#issuecomment-1089026769
#variable "fortigateConfig" {
    
#}