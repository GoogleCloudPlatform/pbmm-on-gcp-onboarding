# This is a per environment file
# The state file path is environment specific
# Development

locals {
  vpc_private_network_project_id = data.terraform_remote_state.networks_nonproduction.outputs.base_host_project_id
  vpc_private_network            = data.terraform_remote_state.networks_nonproduction.outputs.base_network_name
  vpc_private_network_self_link  = data.terraform_remote_state.networks_nonproduction.outputs.base_network_self_link
  vpc_subnets_ips                = data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_ips
  vpc_subnets_names              = data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_names
  vpc_subnets_self_links         = data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_self_links
  # Manage this as part of a comprehensive IPAM system
  # TODO The hard coded numbers are arbitrary!
  internal_ilb_address    = cidrhost(data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_ips, 5)
  private_active_address  = cidrhost(data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_ips, 3)
  private_network_gateway = cidrhost(data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_ips, 1)
  private_passive_address = cidrhost(data.terraform_remote_state.networks_nonproduction.outputs.base_subnets_ips, 4)
  # keys regionX.name
  bu1_regions        = data.terraform_remote_state.bu1_nonproduction.outputs.bu_config[0].region_config
  bu1_primary_region = local.bu1_regions.region1.name
  # keys regionX
  bu1_regions_ips           = data.terraform_remote_state.bu1_nonproduction.outputs.bu_config[0].base_projects[2].ip_ranges
  bu1_primary_region_subnet = bu_regions_ips.region1

  # The lz default region is a mis-match with the base_network region, which should probably be fixed
  #default_region                 = data.terraform_remote_state.bootstrap.outputs.common_config.default_region
  default_region = local.bu1_primary_region
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}

data "terraform_remote_state" "org" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/org/state"
  }
}

# networks / nonproduction
data "terraform_remote_state" "networks_nonproduction" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/nonproduction"
  }
}

data "terraform_remote_state" "bu1_nonproduction" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/projects/business_unit_1/nonproduction"
  }
}
