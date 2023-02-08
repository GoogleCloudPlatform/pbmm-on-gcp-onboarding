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



module "audit_streams_bucket_name" {
  source = "../../../naming-standard//modules/gcp/storage"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = var.bucket_name
}

module "log_sink_name" {
  source = "../../../naming-standard//modules/gcp/log_sink"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = var.sink_name
}