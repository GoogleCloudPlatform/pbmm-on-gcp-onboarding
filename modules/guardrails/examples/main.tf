/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

module "guardrails" {
  source = "../"

  org_id              = var.org_id
  org_client          = false
  billing_account     = var.billing_account
  parent              = var.parent
  owner               = var.owner
  environment         = var.environment
  department_code     = var.department_code
  user_defined_string = "guardrails${random_string.random.result}"
}