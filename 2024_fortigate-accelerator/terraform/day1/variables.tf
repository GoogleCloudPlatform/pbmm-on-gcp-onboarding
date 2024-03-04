locals {
  prefix = data.terraform_remote_state.base.outputs.prefix
  region = data.terraform_remote_state.base.outputs.region
}
