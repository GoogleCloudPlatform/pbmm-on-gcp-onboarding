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

module "audit" {
  source                         = "../"
  billing_account                = var.billing_account
  parent                         = var.parent
  org_id                         = var.org_id
  region                         = var.region
  environment                    = var.environment
  owner                          = var.owner
  department_code                = var.department_code
  user_defined_string            = "utaudit${random_id.random_id.hex}"
  additional_user_defined_string = var.additional_user_defined_string
  audit_streams = {
    prod = {
      bucket_name          = "orgaudit${random_id.random_id.hex}",
      is_locked            = false
      bucket_force_destroy = true       # for testing purposes only
      bucket_storage_class = "STANDARD" # STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE
      labels               = {},
      sink_name            = "orgaudit${random_id.random_id.hex}"
      description          = "Org Sink"
      filter               = "severity >= WARNING",
      retention_period     = 604800,
      environment          = "P"
      department_code      = "Lz"
      bucket_viewer        = var.bucket_viewer,

    },
  }
}