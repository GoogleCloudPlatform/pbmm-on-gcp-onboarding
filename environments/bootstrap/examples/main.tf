/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


resource "random_id" "random_id" {
  byte_length = 2
}

module "bootstrap_project" {
  source = "../"

  department_code                = var.department_code
  user_defined_string            = "Bootstrap"
  additional_user_defined_string = random_id.random_id.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location

  billing_account              = var.billing_account
  parent                       = var.parent
  terraform_deployment_account = "unittest-sa"
  bootstrap_email              = var.bootstrap_email
  org_id                       = var.org_id
  set_billing_iam              = false
  services = [
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ]
  yaml_config_bucket = {
    name = "config${random_id.random_id.hex}"
  }
  tfstate_buckets = {
    common = {
      name = "common${random_id.random_id.hex}",
    },
    nonp = {
      name          = "nonp${random_id.random_id.hex}",
      labels        = { "foo" = "bar" }
      storage_class = "STANDARD"
    },
    prod = {
      name          = "prod${random_id.random_id.hex}",
      labels        = {}
      force_destroy = true
    },
  }
}
