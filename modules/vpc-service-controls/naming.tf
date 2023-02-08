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



module "policy_name" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  department_code     = var.department_code
  environment         = var.environment
  location            = var.location
  user_defined_string = var.user_defined_string
}

module "access_list_names" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  for_each        = var.access_level
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.value.name
}

module "regular_service_perimeter_names" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  for_each        = var.regular_service_perimeter
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.value.perimeter_name
}

module "bridge_service_perimeter_names" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  for_each        = var.bridge_service_perimeter
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.value.perimeter_name
}