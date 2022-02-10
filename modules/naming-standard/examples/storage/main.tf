/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  department_code = "Ga"
  environment     = "D"
  location        = "northamerica-northeast1"
}

module "example_storage" {
  source = "../../modules/gcp/storage"

  department_code = local.department_code
  environment     = local.environment
  location        = local.location

  user_defined_string = var.user_defined_string
}