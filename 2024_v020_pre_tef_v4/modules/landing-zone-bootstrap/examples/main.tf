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

module "bootstrap_project" {
  source = "../"

  department_code                = var.department_code
  user_defined_string            = "Bootstrap"
  additional_user_defined_string = random_id.random_id.hex
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location

  billing_account              = var.billing_account
  parent                       = var.parent
  terraform_deployment_account = "unittest-sa"
  bootstrap_email              = var.bootstrap_email
  org_id                       = var.org_id
  set_billing_iam              = false
  services = [
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ]
  yaml_config_bucket = {
    name = "config${random_id.random_id.hex}"
  }
  tfstate_buckets = {
    common = {
      name = "common${random_id.random_id.hex}",
    },
    nonp = {
      name          = "nonp${random_id.random_id.hex}",
      labels        = { "foo" = "bar" }
      storage_class = "STANDARD"
    },
    prod = {
      name          = "prod${random_id.random_id.hex}",
      labels        = {}
      force_destroy = true
    },
  }
}
