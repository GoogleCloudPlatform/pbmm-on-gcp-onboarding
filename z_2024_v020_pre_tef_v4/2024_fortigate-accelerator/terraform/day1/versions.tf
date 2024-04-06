terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
    }
  }
}

provider "google" {
  project = data.terraform_remote_state.base.outputs.project
  region  = data.terraform_remote_state.base.outputs.region
  zone    = "${data.terraform_remote_state.base.outputs.region}-b"
}

provider "google-beta" {
  project = data.terraform_remote_state.base.outputs.project
  region  = data.terraform_remote_state.base.outputs.region
  zone    = "${data.terraform_remote_state.base.outputs.region}-b"
}

provider "fortios" {
# TODO: automatically find which peer is primary at the moment of deployment
#       for now we just go to he first instance

  hostname  = data.terraform_remote_state.base.outputs.fgt-mgmt-eips[0]
  username  = "admin" 
  password  = "password"
# use username and password or just token below
  #token     = data.terraform_remote_state.base.outputs.api-key
  insecure  = "true"
}
