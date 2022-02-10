/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "network_name" {
  source = "../../../naming-standard//modules/gcp/virtual_private_cloud"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = var.network_name
}
