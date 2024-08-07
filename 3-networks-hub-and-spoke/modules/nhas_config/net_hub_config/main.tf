/*********
 * Copyleft none
 ********/

locals {
  all_config     = yamldecode(file("${var.config_file}"))
  common_config  = local.all_config.common
  onsite_config  = local.all_config.onsite
  config_net_hub = local.common_config.net_hub

  //restricted_enabled         = try(data.terraform_remote_state.bootstrap.outputs.common_config.restricted_enabled,false)
  restricted_enabled = var.restricted_enabled

  vpc_routes_base = concat(try(local.common_config.common_routes, []),
    try(local.config_net_hub.routes, []),
    try(local.config_net_hub.base.routes, [])
  )
  vpc_routes_restricted = try(local.restricted_enabled ? concat(try(local.common_config.spoke_common_routes, []),
    try(local.config_net_hub.routes, []),
    try(local.config_net_hub.restricted.routes, [])
  ) : [], [])

  base_vpc_routes = [for one_route in local.vpc_routes_base : {
    for k, v in one_route : ((k == "name_suffix") ? "name" : k) => (k == "name_suffix") ? "rt-${local.env_code}-shared-base-${local.mode}-${v}" : v
    } if(try(one_route.id, "") != "rt_nat_to_internet" || local.nat_igw_enabled) &&
    (try(one_route.id, "") != "rt_windows_activation" || local.windows_activation_enabled)
  ]
  restricted_vpc_routes = try(local.restricted_enabled ? [for one_route in local.vpc_routes_restricted : {
    for k, v in one_route : ((k == "name_suffix") ? "name" : k) => (k == "name_suffix") ? "rt-${local.env_code}-shared-restricted-${local.mode}-${v}" : v
    } if(try(one_route.id, "") != "rt_nat_to_internet" || local.nat_igw_enabled) &&
    (try(one_route.id, "") != "rt_windows_activation" || local.windows_activation_enabled)
  ] : [], [])

  //regions_config   = local.all_config.regions
  regions_config = {
    for k, v in local.all_config.regions : k => {
      name     = v.name
      enabled  = try(v.enabled, (k == "region1") ? true : false)
      disabled = try(v.enabled, (k == "region2") ? true : false)
    } if(k == "region1" || k == "region2")
  }

  env_code = local.common_config.env_code


  ///***********************************///
  vpc_config      = local.config_net_hub
  mode            = try(local.vpc_config.mode, "hub")
  region1_enabled = try(local.regions_config.region1.enabled, true)
  region2_enabled = try(local.regions_config.region2.enabled, false)
  default_region1 = try(local.regions_config.region1.name, "none")
  default_region2 = try(local.regions_config.region2.name, "none")

  base_spoke_type       = try(local.base_vpc_config.env_type, "shared-base-hub")
  restricted_spoke_type = try(local.restricted_vpc_config.env_type, "shared-restricted-hub")

  base_private_service_connect_ip       = try(local.base_vpc_config.private_service_connect_ip, null)
  restricted_private_service_connect_ip = try(local.restricted_vpc_config.private_service_connect_ip, null)
  base_private_service_cidr             = try(local.base_vpc_config.private_service_cidr, null)
  restricted_private_service_cidr       = try(local.restricted_vpc_config.private_service_cidr, null)


  nat_igw_enabled                   = try(local.vpc_config.nat_igw_enabled, false)
  windows_activation_enabled        = try(local.config_net_hub.windows_activation_enabled, false)
  net_hub_router_ha_enabled         = try(local.config_net_hub.router_ha_enabled, false)
  enable_hub_and_spoke_transitivity = try(local.config_net_hub.enable_hub_and_spoke_transitivity, false)

  ///****************** shared net-hub ********************///

  net_hub_nat_igw_enabled                   = try(local.config_net_hub.nat_igw_enabled, false)
  base_vpc_config                           = local.config_net_hub.base
  restricted_vpc_config                     = try(local.config_net_hub.restricted, null)
  base_hub_nat_igw_enabled                  = try(local.base_vpc_config.nat_igw_enabled, false) || local.net_hub_nat_igw_enabled
  restricted_hub_nat_igw_enabled            = try(local.restricted_vpc_config.nat_igw_enabled, false) || local.net_hub_nat_igw_enabled
  base_hub_windows_activation_enabled       = try(local.base_vpc_config.windows_activation_enabled, false) || local.windows_activation_enabled
  restricted_hub_windows_activation_enabled = try(local.restricted_vpc_config.windows_activation_enabled, false) || local.windows_activation_enabled
  net_hub_vpc_name                          = "${local.env_code}-dns-hub"
  net_hub_network_name                      = "vpc-${local.net_hub_vpc_name}"

  base_hub_dns_enable_inbound_forwarding = local.base_vpc_config.dns_enable_inbound_forwarding
  base_hub_dns_enable_logging            = local.base_vpc_config.dns_enable_logging
  base_hub_firewall_enable_logging       = local.base_vpc_config.firewall_enable_logging
  base_hub_nat_bgp_asn                   = local.base_vpc_config.nat_bgp_asn
  base_hub_nat_num_addresses_region1     = local.base_vpc_config.nat_num_addresses_region1
  base_hub_nat_num_addresses_region2     = local.base_vpc_config.nat_num_addresses_region2

  restricted_hub_dns_enable_inbound_forwarding = try(local.restricted_vpc_config.dns_enable_inbound_forwarding, null)
  restricted_hub_dns_enable_logging            = try(local.restricted_vpc_config.dns_enable_logging, null)
  restricted_hub_firewall_enable_logging       = try(local.restricted_vpc_config.firewall_enable_logging, null)
  restricted_hub_nat_bgp_asn                   = try(local.restricted_vpc_config.nat_bgp_asn, null)
  restricted_hub_nat_num_addresses_region1     = try(local.restricted_vpc_config.nat_num_addresses_region1, null)
  restricted_hub_nat_num_addresses_region2     = try(local.restricted_vpc_config.nat_num_addresses_region2, null)

  //net_hub_vpc_routes =  [ for one_route in local.common_config.common_routes : one_route
  //  if (try(one_route.id,"") != "rt_nat_to_internet" || local.nat_igw_enabled) &&
  //  (try(one_route.id,"") != "rt_windows_activation" || local.windows_activation_enabled)
  //]

  subnet_net_hub_base = flatten(
    [for one_subnet in local.config_net_hub.base.subnets :
      [for one_region_id in keys(local.regions_config) :
        merge(
          {
            subnet_id             = one_subnet.id
            subnet_name           = "sb-${local.env_code}-${local.base_spoke_type}-${one_subnet.id}-${local.regions_config[one_region_id].name}${one_subnet.subnet_suffix}"
            subnet_ip             = one_subnet.ip_ranges[one_region_id]
            subnet_region         = local.regions_config[one_region_id].name
            region_id             = one_region_id
            subnet_private_access = try(one_subnet.private_access, false)
            subnet_flow_logs      = try(one_subnet.flow_logs.enable, false)
            description           = try(one_subnet.description, "First ${local.base_spoke_type} subnet example")
          },
          try(one_subnet.flow_logs.enable, false) ?
          {
            subnet_flow_logs_interval        = try(one_subnet.flow_logs.interval, var.default_vpc_flow_logs.aggregation_interval)
            subnet_flow_logs_metadata        = var.default_vpc_flow_logs.metadata
            subnet_flow_logs_metadata_fields = var.default_vpc_flow_logs.metadata_fields
            subnet_flow_logs_filter          = var.default_vpc_flow_logs.filter_expr
          } : null,
          try(contains(keys(one_subnet), "role") ?
            {
              role = one_subnet.role
            } : null, null
          ),
          try(contains(keys(one_subnet), "purpose") ?
            {
              purpose = one_subnet.purpose
            } : null, null
          ),
          try(contains(keys(one_subnet), "secondary_ranges") ?
            {
              secondary_ranges = (
                [for one_range in one_subnet.secondary_ranges :
                  {
                    range_name    = "rn-${local.env_code}-${local.base_spoke_type}-${local.regions_config[one_region_id].name}-${one_range.range_suffix}"
                    ip_cidr_range = try(one_range.ip_cidr_range[one_region_id], null)
                  } if contains(keys(one_range.ip_cidr_range), one_region_id) && !try(local.regions_config[one_region_id].disabled, false)
              ])
          } : null, null)
        ) if(try(!local.regions_config[one_region_id].disabled, true) && try(can(cidrhost(one_subnet.ip_ranges[one_region_id], 1)), false)) &&
        try(local.config_net_hub.base.enabled, true) && ((one_region_id == "region1" && local.region1_enabled) || (one_region_id == "region2" && local.region2_enabled))
      ]
    ]
  )
  subnet_net_hub_restricted = try(local.restricted_enabled ? flatten(
    [for one_subnet in local.config_net_hub.restricted.subnets :
      [for one_region_id in keys(local.regions_config) :
        merge({
          subnet_id             = one_subnet.id
          subnet_name           = "sb-${local.env_code}-${local.restricted_spoke_type}-${one_subnet.id}-${local.regions_config[one_region_id].name}${one_subnet.subnet_suffix}"
          subnet_ip             = one_subnet.ip_ranges[one_region_id]
          subnet_region         = local.regions_config[one_region_id].name
          region_id             = one_region_id
          subnet_private_access = try(one_subnet.private_access, false)
          subnet_flow_logs      = try(one_subnet.flow_logs.enable, false)
          description           = try(one_subnet.description, "First ${local.restricted_spoke_type} subnet example")
          },
          try(one_subnet.flow_logs.enable, false) ?
          {
            subnet_flow_logs_interval        = try(one_subnet.flow_logs.interval, var.default_vpc_flow_logs.aggregation_interval)
            subnet_flow_logs_metadata        = var.default_vpc_flow_logs.metadata
            subnet_flow_logs_metadata_fields = var.default_vpc_flow_logs.metadata_fields
            subnet_flow_logs_filter          = var.default_vpc_flow_logs.filter_expr
          } : null,
          try(contains(keys(one_subnet), "role") ?
            {
              role = one_subnet.role
            } : null, null
          ),
          try(contains(keys(one_subnet), "purpose") ?
            {
              purpose = one_subnet.purpose
            } : null, null
          ),
          try(contains(keys(one_subnet), "secondary_ranges") ?
            {
              secondary_ranges = (
                [for one_range in one_subnet.secondary_ranges :
                  {
                    range_name    = "rn-${local.env_code}-${local.restricted_spoke_type}-${local.regions_config[one_region_id].name}-${one_range.range_suffix}"
                    ip_cidr_range = try(one_range.ip_cidr_range[one_region_id], null)
                  } if contains(keys(one_range.ip_cidr_range), one_region_id) && !try(local.regions_config[one_region_id].disabled, false)
              ])
          } : null, null)
        ) if(try(!local.regions_config[one_region_id].disabled, true) && try(can(cidrhost(one_subnet.ip_ranges[one_region_id], 1)), false)) &&
        try(local.config_net_hub.restricted.enabled, true) && ((one_region_id == "region1" && local.region1_enabled) || (one_region_id == "region2" && local.region2_enabled))
      ]
    ]
  ) : [], [])
  filtered_base_subnets = [for one_subnet in local.subnet_net_hub_base :
    { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id" && k != "subnet_id") }
  ]
  filtered_restricted_subnets = local.restricted_enabled ? [for one_subnet in local.subnet_net_hub_restricted :
    { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id" && k != "subnet_id") }
  ] : []
  secondary_base_subnets = {
    for one_subnet in local.subnet_net_hub_base : one_subnet.subnet_name =>
    [
      for one_range in one_subnet.secondary_ranges : {
        range_name    = one_range.range_name
        ip_cidr_range = one_range.ip_cidr_range
      }
    ] if contains(keys(one_subnet), "secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0, false)
  }
  secondary_restricted_subnets = try(local.restricted_enabled ? {
    for one_subnet in local.subnet_net_hub_restricted : one_subnet.subnet_name =>
    [
      for one_range in one_subnet.secondary_ranges : {
        range_name    = one_range.range_name
        ip_cidr_range = one_range.ip_cidr_range
      }
    ] if contains(keys(one_subnet), "secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0, false)
  } : null, null)

  base_subnet_primary_ranges = {
    for one_region_id in keys(local.regions_config) : (local.regions_config["${one_region_id}"]).name =>
    one([for one_subnet in local.subnet_net_hub_base : one_subnet.subnet_ip if one_subnet.subnet_id == "primary" && one_subnet.region_id == one_region_id])
  }

  base_subnet_proxy_ranges = {
    for one_region_id in keys(local.regions_config) : (local.regions_config["${one_region_id}"]).name =>
    one([for one_subnet in local.subnet_net_hub_base : one_subnet.subnet_ip if one_subnet.subnet_id == "proxy" && one_subnet.region_id == one_region_id])
  }

  restricted_subnet_primary_ranges = try(local.restricted_enabled ? {
    for one_region_id in keys(local.regions_config) : (local.regions_config["${one_region_id}"]).name =>
    one([for one_subnet in local.subnet_net_hub_restricted : one_subnet.subnet_ip if one_subnet.subnet_id == "primary" && one_subnet.region_id == one_region_id])
  } : null, null)

  restricted_subnet_proxy_ranges = try(local.restricted_enabled ? {
    for one_region_id in keys(local.regions_config) : (local.regions_config["${one_region_id}"]).name =>
    one([for one_subnet in local.subnet_net_hub_restricted : one_subnet.subnet_ip if one_subnet.subnet_id == "proxy" && one_subnet.region_id == one_region_id])
  } : null, null)


  /*********************************/

  on_site_ip_range = local.onsite_config.on_site_ip_range
  all_env_ip_range = local.all_config.spokes.all_env_ip_range

  net_hub_config = {
    regions = {
      region1 = {
        enabled = local.region1_enabled
        default = local.default_region1
      }
      region2 = {
        enabled = local.region2_enabled
        default = local.default_region2
      }
    }
    on_site_ip_range = local.on_site_ip_range
    all_env_ip_range = local.all_env_ip_range
    base = {
      subnet_primary_ranges             = local.base_subnet_primary_ranges
      hub_dns_enable_inbound_forwarding = local.base_hub_dns_enable_inbound_forwarding
      hub_dns_enable_logging            = local.base_hub_dns_enable_logging
      hub_firewall_enable_logging       = local.base_hub_firewall_enable_logging
      hub_nat_bgp_asn                   = local.base_hub_nat_bgp_asn
      hub_nat_num_addresses_region1     = local.base_hub_nat_num_addresses_region1
      hub_nat_num_addresses_region2     = local.base_hub_nat_num_addresses_region2
      hub_windows_activation_enabled    = local.base_hub_windows_activation_enabled
      private_service_cidr              = local.base_private_service_cidr
      private_service_connect_ip        = local.base_private_service_connect_ip
      hub_nat_igw_enabled               = local.base_hub_nat_igw_enabled
      subnet_net_hub = [for one_subnet in local.subnet_net_hub_base :
        { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id") }
      ]

      secondary_subnets  = local.secondary_base_subnets
      net_hub_vpc_routes = local.base_vpc_routes
    }
    restricted = try(local.restricted_enabled ? {
      subnet_primary_ranges             = local.restricted_subnet_primary_ranges
      hub_dns_enable_inbound_forwarding = local.restricted_hub_dns_enable_inbound_forwarding
      hub_dns_enable_logging            = local.restricted_hub_dns_enable_logging
      hub_firewall_enable_logging       = local.restricted_hub_firewall_enable_logging
      hub_nat_bgp_asn                   = local.restricted_hub_nat_bgp_asn
      hub_nat_num_addresses_region1     = local.restricted_hub_nat_num_addresses_region1
      hub_nat_num_addresses_region2     = local.restricted_hub_nat_num_addresses_region2
      hub_windows_activation_enabled    = local.restricted_hub_windows_activation_enabled
      private_service_cidr              = local.restricted_private_service_cidr
      private_service_connect_ip        = local.restricted_private_service_connect_ip
      private_service_connect_ip        = local.restricted_private_service_connect_ip
      hub_nat_igw_enabled               = local.restricted_hub_nat_igw_enabled
      subnet_net_hub = [for one_subnet in local.subnet_net_hub_restricted :
        { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id") }
      ]
      secondary_subnets  = local.secondary_restricted_subnets
      net_hub_vpc_routes = local.restricted_vpc_routes
    } : null, null)
    net_hub_router_ha_enabled = local.net_hub_router_ha_enabled
    // net_hub_vpc_routes                  = local.net_hub_vpc_routes
    nat_igw_enabled                   = local.nat_igw_enabled
    windows_activation_enabled        = local.windows_activation_enabled
    enable_hub_and_spoke_transitivity = local.enable_hub_and_spoke_transitivity
  }
}

