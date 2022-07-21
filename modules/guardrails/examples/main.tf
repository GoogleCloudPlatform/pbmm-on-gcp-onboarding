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