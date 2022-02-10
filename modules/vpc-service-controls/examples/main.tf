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

module "project_1" {
  source          = "../project"
  billing_account = var.billing_account
  name            = "unittest-project-1-${random_id.random_id.hex}"
  parent          = var.parent
  services        = []
}


module "project_2" {
  source          = "../project"
  billing_account = var.billing_account
  name            = "unittest-project-2-${random_id.random_id.hex}"
  parent          = var.parent
  services        = []
}

module "svc_ctl" {
  source              = "../"
  parent_id           = var.parent_id
  policy_name         = "test-policy-1"
  policy_id           = var.policy_id
  user_defined_string = var.user_defined_string
  location            = var.location
  department_code     = var.department_code
  environment         = var.environment
  access_level = {
    basic = {
      description = "Simple Example Access Level"
      name        = var.access_level_name
      members     = var.members
      regions     = var.regions
    }
  }
  regular_service_perimeter = {
    regular_service_perimeter_1 = {
      perimeter_name       = var.regular_perimeter_name
      description          = "Some description"
      resources_by_numbers = [module.project_1.number, module.project_2.number]
      access_levels        = ["scdevsc_${var.access_level_name}_vsc"]
      live_run             = true
    }
  }
  bridge_service_perimeter = {
    bridge_service_perimeter_1 = {
      perimeter_name       = var.bridge_perimeter_name
      description          = "Some description"
      resources_by_numbers = [module.project_1.number, module.project_2.number]
    }
  }
}