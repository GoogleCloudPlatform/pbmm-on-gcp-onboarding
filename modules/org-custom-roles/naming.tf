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
module "custom_role_names" {
  source = "../naming-standard//modules/gcp/custom_role"

  for_each        = local.platform_roles
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${each.value.role_id}_${random_id.random_id.hex}"
}