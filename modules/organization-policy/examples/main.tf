/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "policies" {
  source                = "../"
  organization_id       = var.organization_id
  directory_customer_id = var.directory_customer_id
}
