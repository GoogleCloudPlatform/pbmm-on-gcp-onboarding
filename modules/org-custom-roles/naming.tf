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
module "custom_role_names" {
  source = "../naming-standard//modules/gcp/custom_role"

  for_each        = local.platform_roles
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${each.value.role_id}_${random_id.random_id.hex}"
}