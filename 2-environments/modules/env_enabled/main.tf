/*********
 * Copyleft none
 ********/
locals {
  restricted_enabled  = try(data.terraform_remote_state.bootstrap.outputs.common_config.restricted_enabled,false)
  management_enabled  = try(data.terraform_remote_state.bootstrap.outputs.common_config.management_enabled,false)
  identity_enabled    = try(data.terraform_remote_state.bootstrap.outputs.common_config.identity_enabled,false)
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}
