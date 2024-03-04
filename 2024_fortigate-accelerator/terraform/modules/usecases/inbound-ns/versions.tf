terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
    }
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

/*
provider "google" {
  project = var.day0.project
  region  = var.day0.region
  zone    = "${var.day0.region}-b"
}

provider "google-beta" {
  project = var.day0.project
  region  = var.day0.region
  zone    = "${var.day0.region}-b"
}

provider "fortios" {
# TODO: automatically find which peer is primary at the moment of deployment
#       for now we just go to he first instance

  hostname  = var.day0.fgt-vm-eip[0]
  token     = var.day0.api-key
  insecure  = "true"
}
*/
