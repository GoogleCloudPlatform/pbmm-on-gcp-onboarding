/*********
 * Copyleft none
 ********/

locals {
  all_config       = yamldecode(file("${var.config_file}"))
  spokes_config    = local.all_config.spokes
  common_config    = local.all_config.common
  one_spoke_config = local.spokes_config[var.env]

  restricted_enabled = var.restricted_enabled

  vpc_routes_base = concat(try(local.spokes_config.spoke_common_routes, []),
    try(local.one_spoke_config.routes, []),
    try(local.one_spoke_config.base.routes, [])
  )
  vpc_routes_restricted = try(local.restricted_enabled ? concat(try(local.spokes_config.spoke_common_routes, []),
    try(local.one_spoke_config.routes, []),
    try(local.one_spoke_config.restricted.routes, [])
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


  environment_code = local.one_spoke_config.env_code
  env_enabled      = try(local.one_spoke_config.env_enabled, true)


  ///***********************************///
  vpc_config                            = local.one_spoke_config
  mode                                  = try(local.vpc_config.mode, "spoke")
  region1_enabled                       = try(local.regions_config.region1.enabled, true)
  region2_enabled                       = try(local.regions_config.region2.enabled, false)
  default_region1                       = try(local.regions_config.region1.name, "none")
  default_region2                       = try(local.regions_config.region2.name, "none")
  base_vpc_config                       = local.vpc_config.base
  restricted_vpc_config                 = try(local.restricted_enabled ? local.vpc_config.restricted : null, null)
  base_spoke_type                       = try(local.base_vpc_config.env_type, "shared-base")
  restricted_spoke_type                 = try(local.restricted_vpc_config.env_type, "shared-restricted")
  base_private_service_connect_ip       = local.base_vpc_config.private_service_connect_ip
  restricted_private_service_connect_ip = try(local.restricted_enabled ? local.restricted_vpc_config.private_service_connect_ip : null, null)
  base_private_service_cidr             = try(local.base_vpc_config.private_service_cidr, null)
  restricted_private_service_cidr       = try(local.restricted_enabled ? local.restricted_vpc_config.private_service_cidr : null, null)
  nat_igw_enabled                       = try(local.vpc_config.nat_igw_enabled, false)
  windows_activation_enabled            = try(local.vpc_config.windows_activation_enabled, false)
  router_ha_enabled                     = try(local.vpc_config.router_ha_enabled, false)
  enable_hub_and_spoke_transitivity     = try(local.vpc_config.enable_hub_and_spoke_transitivity, false)
  env_code                              = local.vpc_config.env_code

  subnet_base = flatten(
    [for one_subnet in local.vpc_config.base.subnets :
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
          try(contains(keys(one_subnet), "service_projects") ?
            {
              service_projects = one_subnet.service_projects
            } : null, null
          ),
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
        try(local.env_enabled, false) && try(local.vpc_config.base.enabled, false) &&
        ((one_region_id == "region1" && local.region1_enabled) || (one_region_id == "region2" && local.region2_enabled))
      ]

    ]
  )
  subnet_restricted = try(local.restricted_enabled ? flatten(
    [for one_subnet in local.vpc_config.restricted.subnets :
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
          try(contains(keys(one_subnet), "service_projects") ?
            {
              service_projects = one_subnet.service_projects
            } : null, null
          ),
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
        try(local.env_enabled, false) && try(local.vpc_config.restricted.enabled, false) &&
        ((one_region_id == "region1" && local.region1_enabled) || (one_region_id == "region2" && local.region2_enabled))
      ]

    ]
  ) : [], [])
  filtered_base_subnets = [for one_subnet in local.subnet_base :
    { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id" && k != "service_projects") }
  ]
  filtered_restricted_subnets = try(local.restricted_enabled ? [for one_subnet in local.subnet_restricted :
    { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id" && k != "service_projects") }
  ] : [], [])
  filtered_base_subnets_names       = [for one_subnet in local.filtered_base_subnets : one_subnet.subnet_name]
  filtered_base_subnets_ips         = [for one_subnet in local.filtered_base_subnets : one_subnet.subnet_ip]
  filtered_restricted_subnets_names = try(local.restricted_enabled ? [for one_subnet in local.filtered_restricted_subnets : one_subnet.subnet_name] : [], [])
  filtered_restricted_subnets_ips   = try(local.restricted_enabled ? [for one_subnet in local.filtered_restricted_subnets : one_subnet.subnet_ip] : [], [])

  secondary_base_subnets = {
    for one_subnet in local.subnet_base : one_subnet.subnet_name =>
    [
      for one_range in one_subnet.secondary_ranges : {
        range_name    = one_range.range_name
        ip_cidr_range = one_range.ip_cidr_range
      }
    ] if contains(keys(one_subnet), "secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0, false)
  }
  secondary_restricted_subnets = try(local.restricted_enabled ? {
    for one_subnet in local.subnet_restricted : one_subnet.subnet_name =>
    [
      for one_range in one_subnet.secondary_ranges : {
        range_name    = one_range.range_name
        ip_cidr_range = one_range.ip_cidr_range
      }
    ] if contains(keys(one_subnet), "secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0, false)
  } : {}, {})

  ///*****************************************************///
  spoke_config = {
    vpc_config = local.one_spoke_config
    vpc_routes = {
      base       = local.vpc_routes_base
      restricted = local.vpc_routes_restricted
    }
    regions_config    = local.regions_config
    env_enabled       = local.env_enabled
    node              = local.mode
    nat_enabled       = local.nat_igw_enabled
    router_ha_enabled = local.router_ha_enabled
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

    base = {
      private_service_cidr       = local.base_private_service_cidr
      private_service_connect_ip = local.base_private_service_connect_ip
      vpc_routes                 = local.base_vpc_routes
      secondary_ranges           = local.secondary_base_subnets
      subnets                    = local.subnet_base
      filtered_subnets           = local.filtered_base_subnets
      filtered_subnets_names     = local.filtered_base_subnets_names
      filtered_subnets_ips       = local.filtered_base_subnets_ips
    }

    restricted = local.restricted_enabled ? {
      private_service_cidr       = local.restricted_private_service_cidr
      private_service_connect_ip = local.restricted_private_service_connect_ip
      vpc_routes                 = local.restricted_vpc_routes
      secondary_ranges           = local.secondary_restricted_subnets
      subnets                    = local.subnet_restricted
      filtered_subnets           = local.filtered_restricted_subnets
      filtered_subnets_names     = local.filtered_restricted_subnets_names
      filtered_subnets_ips       = local.filtered_restricted_subnets_ips
    } : null

  }

}

