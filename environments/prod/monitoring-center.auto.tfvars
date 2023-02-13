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

monitoring_centers = {
  prod-monitoring-center = {
    user_defined_string            = "REPLACE_MONITORING_PROJECT_PROD_USD"                        # REQUIRED EDIT must contribute to being globally unique
    additional_user_defined_string = ""                        # OPTIONAL EDIT check 61 char aggregate limit
    billing_account                = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
    projectlabels = {
      creator     = ""
      environment = "prod"
    }
    monitoring_center_viewers = ["REPLACE_MONITORING_VIEW_EMAIL"] # REQUIRED EDIT.
  }
}
