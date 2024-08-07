/*********
 * Copyleft none
 ********/

locals {
  all_config       = yamldecode(file("${var.config_file}"))
  common_config    = local.all_config.common
  all_env_ip_range = local.all_config.spokes.all_env_ip_range
  onsite_config    = local.all_config.onsite
  config_dns_hub   = local.common_config.dns_hub
  vpc_routes       = concat(try(local.all_config.common_routes, []), try(local.common_config.routes, []))
  dns_hub_routes = [for one_route in local.vpc_routes : {
    for k, v in one_route : ((k == "name_suffix") ? "name" : k) => (k == "name_suffix") ? "rt-${local.env_code}-dns_hub-${v}" : v
    } if(try(one_route.id, "") != "rt_nat_to_internet" || local.nat_igw_enabled)
  ]

  regions_config = {
    for k, v in local.all_config.regions : k => {
      name     = v.name
      enabled  = try(v.enabled, (k == "region1") ? true : false)
      disabled = try(v.enabled, (k == "region2") ? true : false)
    } if(k == "region1" || k == "region2")
  }
  env_code                     = local.common_config.env_code
  nat_igw_enabled              = try(local.config_dns_hub.nat_igw_enabled, false)
  router_ha_enabled            = try(local.config_dns_hub.router_ha_enabled, false)
  dns_hub_vpc_name             = "${local.env_code}-dns-hub"
  dns_hub_network_name         = "vpc-${local.dns_hub_vpc_name}"
  region1_enabled              = try(local.regions_config.region1.enabled, true)
  region2_enabled              = try(local.regions_config.region2.enabled, false)
  default_region1              = try(local.regions_config.region1.name, "none")
  default_region2              = try(local.regions_config.region2.name, "none")
  on_site_ip_range             = local.onsite_config.on_site_ip_range
  dns_vpc_ip_range             = local.config_dns_hub.dns_vpc_ip_range
  target_name_server_addresses = local.config_dns_hub.target_servers

  subnet_dns_hub = flatten(
    [for one_subnet in local.config_dns_hub.subnets :
      [for one_region_id in keys(local.regions_config) :
        merge(
          {
            subnet_id             = one_subnet.id
            subnet_name           = "sb-${local.env_code}-${local.config_dns_hub.env_type}-${one_subnet.id}-${local.regions_config[one_region_id].name}${one_subnet.subnet_suffix}"
            subnet_ip             = one_subnet.ip_ranges[one_region_id]
            subnet_region         = local.regions_config[one_region_id].name
            region_id             = one_region_id
            subnet_private_access = try(one_subnet.private_access, false)
            subnet_flow_logs      = try(one_subnet.flow_logs.enable, false)
            description           = try(one_subnet.description, "First ${local.config_dns_hub.env_type} subnet example")
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
                    range_name    = "rn-${local.env_code}-${local.config_dns_hub.env_type}-${local.regions_config[one_region_id].name}-${one_range.range_suffix}"
                    ip_cidr_range = try(one_range.ip_cidr_range[one_region_id], null)
                  } if contains(keys(one_range.ip_cidr_range), one_region_id) && !try(local.regions_config[one_region_id].disabled, false)
              ])
          } : null, null)
        ) if(!try(local.regions_config[one_region_id].disabled, false) && try(can(cidrhost(one_subnet.ip_ranges[one_region_id], 1)), false))
      ]
    ]
  )
  filtered_dns_hub_subnets = [for one_subnet in local.subnet_dns_hub :
    { for k, v in one_subnet : k => v if(k != "secondary_ranges" && k != "region_id") }
  ]

  secondary_dns_hub_subnets = {
    for one_subnet in local.subnet_dns_hub : one_subnet.subnet_name =>
    [
      for one_range in one_subnet.secondary_ranges : {
        range_name    = one_range.range_name
        ip_cidr_range = one_range.ip_cidr_range
      }
    ] if contains(keys(one_subnet), "secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0, false)
  }

  dns_hub_config = {
    // TODO
    subnet_dns_hub       = local.subnet_dns_hub
    dns_hub_network_name = local.dns_hub_network_name
    vpc_routes           = local.dns_hub_routes
    router_ha_enabled    = local.router_ha_enabled
    nat_igw_enabled      = local.nat_igw_enabled
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
    target_name_server_addresses = local.target_name_server_addresses
    on_site_ip_range             = local.on_site_ip_range
    all_env_ip_range             = local.all_env_ip_range
    dns_vpc_ip_range             = local.dns_vpc_ip_range
  }
}



