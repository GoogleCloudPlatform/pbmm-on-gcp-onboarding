/**
 * Copyright 2023 Google LLC
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



prod_workload_net = {
  user_defined_string            = "prd" # Must be globally unique. Used to create project name
  additional_user_defined_string = "client"# "host3"#"host2"
  billing_account                = "REPLACE_WITH_BILLING_ID" ######-######-###### # required
  services                       = [
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigquerystorage.googleapis.com"
  ]
  networks = [
  ]
  labels = {}
}
