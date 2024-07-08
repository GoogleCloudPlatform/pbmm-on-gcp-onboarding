# This is a per environment file
# The state file path is environment specific
# Development

locals {
  # base_net_hub_project_id
  vpc_private_network_project_id = data.terraform_remote_state.networks_shared.outputs.base_shared_vpc_project_id
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
