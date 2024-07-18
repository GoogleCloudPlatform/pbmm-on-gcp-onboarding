# This is a per environment file
# The state file path is environment specific
# Development

locals {
  # TODO hard coded for expedience
  # This should be captured from previous state if at all possible.
  # All subnets originate in config/vpc_config.yaml
  prod_pub_snet_range  = "10.10.4.0/24"
  prod_app_snet_range  = "10.10.5.0/25"
  prod_data_snet_range = "10.10.7.0/25"

  nprod_pub_snet_range  = "10.10.2.0/25"
  nprod_app_snet_range  = "10.10.2.128/26"
  nprod_data_snet_range = "10.10.2.192/26"

  dev_pub_snet_range  = "10.10.1.0/25"
  dev_app_snet_range  = "10.10.1.128/26"
  dev_data_snet_range = "10.10.1.192/26"

  mgmt_snet_range = "10.10.0.0/25"
  iden_snet_range = "10.10.128.0/25"

  prod_vpc_project_id = data.terraform_remote_state.prod_networking.outputs.base_host_project_id
  prod_vpc_name       = data.terraform_remote_state.prod_networking.outputs.base_network_name

  nprod_vpc_project_id = data.terraform_remote_state.nprod_networking.outputs.base_host_project_id
  nprod_vpc_name       = data.terraform_remote_state.nprod_networking.outputs.base_network_name

  dev_vpc_project_id = data.terraform_remote_state.dev_networking.outputs.base_host_project_id
  dev_vpc_name       = data.terraform_remote_state.dev_networking.outputs.base_network_name

  vpc_private_network_project_id = regex("prj-net-hub-base-\\w+", data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_self_links[0])
  vpc_private_network            = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_network_name
  vpc_private_network_self_link  = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_network_self_link
  vpc_subnets_ips                = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_ips
  vpc_subnets_names              = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_names
  vpc_subnets_self_links         = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_self_links
  default_region                 = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_regions[0]
  # Manage this as part of a comprehensive IPAM system
  # The hard coded numbers are arbitrary!
  internal_ilb_address    = cidrhost(data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_ips[0], 5)
  private_active_address  = cidrhost(data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_ips[0], 3)
  private_network_gateway = cidrhost(data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_ips[0], 1)
  private_passive_address = cidrhost(data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_subnets_ips[0], 4)
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
    prefix = "terraform/networks/envs/production"
  }
}

data "terraform_remote_state" "nprod_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/envs/nonproduction"
  }
}

data "terraform_remote_state" "dev_networking" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/envs/development"
  }
}
