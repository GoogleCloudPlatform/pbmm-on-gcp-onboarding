/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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