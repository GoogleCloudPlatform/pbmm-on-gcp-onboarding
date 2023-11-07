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

variable "org_policies" {
  description = "Optional additional policies"
  type = object({
    directory_customer_id   = optional(list(string), null)
    policy_boolean          = optional(object({}), null)
    policy_list             = optional(object({}), null)
    setDefaultPolicy        = bool
    vmAllowedWithExternalIp = list(string)
    vmAllowedWithIpForward  = list(string)
  })
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
    audit_labels = optional(object({}), null)
    audit_services         = optional(list(string), null)
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
      project = optional(string, null)
    }
  ))
  default = []
}

variable "guardrails_project_iam" {
  description = "List of accounts that exist outside the project to grant roles to within the project"
  type = list(object(
    {
      member  = string
      roles   = list(string)
      project = optional(string, null)
    }
  ))
  default = []
}

variable "folder_iam" {
  description = "List of accounts to grant roles to on a specified folder/########"
  type = list(object({
    member      = string
    roles       = list(string)
    folder      = optional(string, null)
    folder_name = string
  }))
  default = []
}
variable "organization_iam" {
  description = "List of accounts to grant roles to with to the organizations/#######"
  type = list(object({
    member       = string
    roles        = list(string)
    organization = optional(string, null)
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
    project      = optional(string, null)
  }))
  default = []
}

variable "guardrails" {
  type = object({
    billing_account     = string
    org_id_scan_list    = list(string)
    org_client          = bool
    user_defined_string = string
    guardrails_services = optional(list(string), null)
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
    labels                         = optional(object({}), null)
    networks = list(object({
      network_name                           = string
      description                            = optional(string, null)
      routing_mode                           = optional(string, null)
      shared_vpc_host                        = optional(bool)
      auto_create_subnetworks                = optional(bool)
      delete_default_internet_gateway_routes = optional(bool)
      peer_project                           = optional(string, null)
      peer_network                           = optional(string, null)
      export_peer_custom_routes              = optional(bool)
      export_local_custom_routes             = optional(bool)
      mtu                                    = optional(number)
      subnets = list(object({
        subnet_name           = string
        description           = optional(string, null)
        subnet_private_access = optional(bool)
        subnet_region         = optional(string, null)
        subnet_ip             = string
        secondary_ranges = optional(list(object({
          range_name    = string
          ip_cidr_range = string
        })))
        log_config = optional(object({
          aggregation_interval = optional(string, null)
          flow_sampling        = optional(number)
          metadata             = optional(string, null)
        }))
      }))
      routes = optional(list(object({
        route_name                        = string
        description                       = optional(string, null)
        destination_range                 = string
        next_hop_default_internet_gateway = optional(bool)
        next_hop_gateway                  = optional(string, null)
        next_hop_ip                       = optional(string, null)
        next_hop_instance                 = optional(string, null)
        next_hop_instance_zone            = optional(string, null)
        next_hop_vpn_tunnel               = optional(string, null)
        priority                          = optional(number)
        tags                              = optional(list(string), null)
      })))
      routers = optional(list(object({
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
        bgp = optional(object({
          asn               = number
          advertise_mode    = optional(string, null)
          advertised_groups = optional(list(string), null)
          advertised_ip_ranges = optional(list(object({
            range       = string
            description = optional(string, null)
          })))
        }))
      })))
      nat_config = optional(list(object({
        nat_name    = string
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
      })))
      vpn_config = optional(list(object({
        ha_vpn_name     = string
        ext_vpn_name    = optional(string, null)
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
      description                            = optional(string, null)
      routing_mode                           = optional(string, null)
      shared_vpc_host                        = optional(bool)
      auto_create_subnetworks                = optional(bool)
      delete_default_internet_gateway_routes = optional(bool)
      peer_project                           = optional(string, null)
      peer_network                           = optional(string, null)
      export_peer_custom_routes              = optional(bool)
      export_local_custom_routes             = optional(bool)
      mtu                                    = optional(number)
      subnets = list(object({
        subnet_name           = string
        description           = optional(string, null)
        subnet_private_access = optional(bool)
        subnet_region         = optional(string, null)
        subnet_ip             = string
        secondary_ranges = optional(list(object({
          range_name    = string
          ip_cidr_range = string
        })))
        log_config = optional(object({
          aggregation_interval = optional(string, null)
          flow_sampling        = optional(number)
          metadata             = optional(string, null)
        }))
      }))
      routes = optional(list(object({
        route_name                        = string
        description                       = optional(string, null)
        destination_range                 = string
        next_hop_default_internet_gateway = optional(bool)
        next_hop_gateway                  = optional(string, null)
        next_hop_ip                       = optional(string, null)
        next_hop_instance                 = optional(string, null)
        next_hop_instance_zone            = optional(string, null)
        next_hop_vpn_tunnel               = optional(string, null)
        priority                          = optional(number)
        tags                              = optional(list(string), null)
      })))
      routers = optional(list(object({
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
        bgp = optional(object({
          asn               = number
          advertise_mode    = optional(string, null)
          advertised_groups = optional(list(string), null)
          advertised_ip_ranges = optional(list(object({
            range       = string
            description = optional(string, null)
          })))
        }))
      })))
      nat_config = optional(list(object({
        nat_name    = string
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
      })))
      vpn_config = optional(list(object({
        ha_vpn_name     = string
        ext_vpn_name    = optional(string, null)
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
      description                            = optional(string, null)
      routing_mode                           = optional(string, null)
      shared_vpc_host                        = optional(bool)
      auto_create_subnetworks                = optional(bool)
      delete_default_internet_gateway_routes = optional(bool)
      peer_project                           = optional(string, null)
      peer_network                           = optional(string, null)
      export_peer_custom_routes              = optional(bool)
      export_local_custom_routes             = optional(bool)
      mtu                                    = optional(number)
      subnets = list(object({
        subnet_name           = string
        description           = optional(string, null)
        subnet_private_access = optional(bool)
        subnet_region         = optional(string, null)
        subnet_ip             = string
        secondary_ranges = optional(list(object({
          range_name    = string
          ip_cidr_range = string
        })))
        log_config = optional(object({
          aggregation_interval = optional(string, null)
          flow_sampling        = optional(number)
          metadata             = optional(string, null)
        }))
      }))
      routes = optional(list(object({
        route_name                        = string
        description                       = optional(string, null)
        destination_range                 = string
        next_hop_default_internet_gateway = optional(bool)
        next_hop_gateway                  = optional(string, null)
        next_hop_ip                       = optional(string, null)
        next_hop_instance                 = optional(string, null)
        next_hop_instance_zone            = optional(string, null)
        next_hop_vpn_tunnel               = optional(string, null)
        priority                          = optional(number)
        tags                              = optional(list(string), null)
      })))
      routers = optional(list(object({
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
        bgp = optional(object({
          asn               = number
          advertise_mode    = optional(string, null)
          advertised_groups = optional(list(string), null)
          advertised_ip_ranges = optional(list(object({
            range       = string
            description = optional(string, null)
          })))
        }))
      })))
      nat_config = optional(list(object({
        nat_name    = string
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
      })))
      vpn_config = optional(list(object({
        ha_vpn_name     = string
        ext_vpn_name    = optional(string, null)
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
      description                            = optional(string, null)
      routing_mode                           = optional(string, null)
      shared_vpc_host                        = optional(bool)
      auto_create_subnetworks                = optional(bool)
      delete_default_internet_gateway_routes = optional(bool)
      peer_project                           = optional(string, null)
      peer_network                           = optional(string, null)
      export_peer_custom_routes              = optional(bool)
      export_local_custom_routes             = optional(bool)
      mtu                                    = optional(number)
      subnets = list(object({
        subnet_name           = string
        description           = optional(string, null)
        subnet_private_access = optional(bool)
        subnet_region         = optional(string, null)
        subnet_ip             = string
        secondary_ranges = optional(list(object({
          range_name    = string
          ip_cidr_range = string
        })))
        log_config = optional(object({
          aggregation_interval = optional(string, null)
          flow_sampling        = optional(number)
          metadata             = optional(string, null)
        }))
      }))
      routes = optional(list(object({
        route_name                        = string
        description                       = optional(string, null)
        destination_range                 = string
        next_hop_default_internet_gateway = optional(bool)
        next_hop_gateway                  = optional(string, null)
        next_hop_ip                       = optional(string, null)
        next_hop_instance                 = optional(string, null)
        next_hop_instance_zone            = optional(string, null)
        next_hop_vpn_tunnel               = optional(string, null)
        priority                          = optional(number)
        tags                              = optional(list(string), null)
      })))
      routers = optional(list(object({
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
        bgp = optional(object({
          asn               = number
          advertise_mode    = optional(string, null)
          advertised_groups = optional(list(string), null)
          advertised_ip_ranges = optional(list(object({
            range       = string
            description = optional(string, null)
          })))
        }))
      })))
      nat_config = optional(list(object({
        nat_name    = string
        router_name = string
        description = optional(string, null)
        region      = optional(string, null)
      })))
      vpn_config = optional(list(object({
        ha_vpn_name     = string
        ext_vpn_name    = optional(string, null)
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
        disabled  = bool
        priority  = number
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

variable "logging_centers" {
  type = map(object({
    user_defined_string            = string
    additional_user_defined_string = optional(string, null)
    projectlabels                  = optional(map(string))
    project_services               = optional(list(string), null)
    central_log_bucket = optional(object({
      name           = string
      description    = string
      location       = string
      retention_days = number
      source_organization_sink = optional(object({
        organization_id  = string
        include_children = optional(bool)
        inclusion_filter = optional(string, null)
        disabled         = optional(bool)
      }))
      source_folder_sink = optional(object({
        folder           = string
        include_children = optional(bool)
        inclusion_filter = optional(string, null)
        disabled         = optional(bool)
      }))
      exporting_project_sink = optional(object({
        destination_bucket          = string
        destination_bucket_location = string
        destination_project         = string
        retention_period            = number
        unique_writer_identity      = bool
        inclusion_filter            = optional(string, null)
        disabled                    = optional(bool)
      }))
    }))
    logging_center_viewers = optional(list(string), null)
  }))
  description = "Input value for the centralized logging projects"
  default     = {}
}

variable "monitoring_centers" {
  type = map(object({
    user_defined_string            = string
    additional_user_defined_string = optional(string, null)
    projectlabels                  = optional(map(string))
    project                        = optional(string, null)
    monitored_projects             = optional(list(any))
    monitoring_center_viewers      = optional(list(string), null)
  }))
  description = "Input value for the centralized monitoring projects"
  default     = {}
}

# keep fortigate config off until finalized a cloud build issue - see 
# https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/pull/43#issuecomment-1089026769
#variable "fortigateConfig" {
    
#}
