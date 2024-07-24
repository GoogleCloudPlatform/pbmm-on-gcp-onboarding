# This is a per environment file
# The state file path is environment specific
# Development

locals {

  ########################################
  # Production 

  prod_pub_idx = one([
    for index, s in data.terraform_remote_state.prod_networking.outputs.base_subnets_names : index if can(regex(".*prod-public.*", s))
  ])

  prod_app_idx = one([
    for index, s in data.terraform_remote_state.prod_networking.outputs.base_subnets_names : index if can(regex(".*prod-app.*", s))
  ])

  prod_data_idx = one([
    for index, s in data.terraform_remote_state.prod_networking.outputs.base_subnets_names : index if can(regex(".*prod-data.*", s))
  ])

  #prod_pub_snet_range  = "10.10.4.0/24"
  #prod_app_snet_range  = "10.10.5.0/25"
  #prod_data_snet_range = "10.10.7.0/25"

  prod_pub_snet_range  = data.terraform_remote_state.prod_networking.outputs.base_subnets_ips[local.prod_pub_idx]
  prod_app_snet_range  = data.terraform_remote_state.prod_networking.outputs.base_subnets_ips[local.prod_app_idx]
  prod_data_snet_range = data.terraform_remote_state.prod_networking.outputs.base_subnets_ips[local.prod_data_idx]

  prod_vpc_project_id = data.terraform_remote_state.prod_networking.outputs.base_host_project_id
  prod_vpc_name       = data.terraform_remote_state.prod_networking.outputs.base_network_name

  ########################################
  # Nonproduction 

  nprod_pub_idx = one([
    for index, s in data.terraform_remote_state.nprod_networking.outputs.base_subnets_names : index if can(regex(".*np-public.*", s))
  ])

  nprod_app_idx = one([
    for index, s in data.terraform_remote_state.nprod_networking.outputs.base_subnets_names : index if can(regex(".*np-app.*", s))
  ])

  nprod_data_idx = one([
    for index, s in data.terraform_remote_state.nprod_networking.outputs.base_subnets_names : index if can(regex(".*np-data.*", s))
  ])

  # nprod_pub_snet_range  = "10.10.2.0/25"
  # nprod_app_snet_range  = "10.10.2.128/26"
  # nprod_data_snet_range = "10.10.2.192/26"

  nprod_pub_snet_range  = data.terraform_remote_state.nprod_networking.outputs.base_subnets_ips[local.nprod_pub_idx]
  nprod_app_snet_range  = data.terraform_remote_state.nprod_networking.outputs.base_subnets_ips[local.nprod_app_idx]
  nprod_data_snet_range = data.terraform_remote_state.nprod_networking.outputs.base_subnets_ips[local.nprod_data_idx]

  nprod_vpc_project_id = data.terraform_remote_state.nprod_networking.outputs.base_host_project_id
  nprod_vpc_name       = data.terraform_remote_state.nprod_networking.outputs.base_network_name

  ########################################
  # Development

  dev_pub_idx = one([
    for index, s in data.terraform_remote_state.dev_networking.outputs.base_subnets_names : index if can(regex(".*dev-public.*", s))
  ])

  dev_app_idx = one([
    for index, s in data.terraform_remote_state.dev_networking.outputs.base_subnets_names : index if can(regex(".*dev-app.*", s))
  ])

  dev_data_idx = one([
    for index, s in data.terraform_remote_state.dev_networking.outputs.base_subnets_names : index if can(regex(".*dev-data.*", s))
  ])

  # dev_pub_snet_range  = "10.10.1.0/25"
  # dev_app_snet_range  = "10.10.1.128/26"
  # dev_data_snet_range = "10.10.1.192/26"

  dev_pub_snet_range  = data.terraform_remote_state.dev_networking.outputs.base_subnets_ips[local.dev_pub_idx]
  dev_app_snet_range  = data.terraform_remote_state.dev_networking.outputs.base_subnets_ips[local.dev_app_idx]
  dev_data_snet_range = data.terraform_remote_state.dev_networking.outputs.base_subnets_ips[local.dev_data_idx]

  dev_vpc_project_id = data.terraform_remote_state.dev_networking.outputs.base_host_project_id
  dev_vpc_name       = data.terraform_remote_state.dev_networking.outputs.base_network_name

  ########################################
  # Management

  mgmt_pri_idx = one([
    for index, s in data.terraform_remote_state.mgmt_networking.outputs.base_subnets_names : index if can(regex(".*mgmt-primary.*", s))
  ])

  # mgmt_pri_snet_range = "10.10.0.0/25"

  mgmt_pri_snet_range = data.terraform_remote_state.mgmt_networking.outputs.base_subnets_ips[local.mgmt_pri_idx]

  ########################################
  # Identity

  iden_pri_idx = one([
    for index, s in data.terraform_remote_state.iden_networking.outputs.base_subnets_names : index if can(regex(".*iden-primary.*", s))
  ])

  # iden_pri_snet_range = "10.10.128.0/25"

  iden_pri_snet_range = data.terraform_remote_state.iden_networking.outputs.base_subnets_ips[local.iden_pri_idx]

  ########################################
  # Everything else
  #
  primary_subnet_idx = one([
    for index, s in data.terraform_remote_state.prod_networking.outputs.base_shared_vpc_subnets_names : index if can(!regex(".*proxy.*", s))
  ])

  vpc_primary_subnet = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_ips[local.primary_subnet_idx]

  vpc_private_network_project_id = regex("prj-net-hub-base-\\w+", data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_self_links[0])
  vpc_private_network            = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_network_name
  vpc_private_network_self_link  = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_network_self_link
  vpc_subnets_names              = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_names
  vpc_subnets_self_links         = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_self_links
  default_region                 = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_regions[0]
  # Manage this as part of a comprehensive IPAM system
  # The hard coded numbers are arbitrary, but reasonable.
  internal_ilb_address    = cidrhost(local.vpc_primary_subnet, 5)
  private_network_gateway = cidrhost(local.vpc_primary_subnet, 1)
  private_active_address  = cidrhost(local.vpc_primary_subnet, 3)
  private_passive_address = cidrhost(local.vpc_primary_subnet, 4)
}

# networks / shared
data "terraform_remote_state" "networks_shared" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/envs/shared"
  }
}

data "terraform_remote_state" "prod_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/production"
  }
}

data "terraform_remote_state" "nprod_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/nonproduction"
  }
}

data "terraform_remote_state" "dev_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/development"
  }
}

data "terraform_remote_state" "mgmt_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/management"
  }
}

data "terraform_remote_state" "ident_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/identity"
  }
}
