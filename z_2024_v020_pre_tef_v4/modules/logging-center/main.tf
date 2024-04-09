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

module "logging_center_project" {
  source                                  = "../project"
  department_code                         = var.department_code
  environment                             = var.environment
  location                                = var.location
  owner                                   = var.owner
  user_defined_string                     = var.user_defined_string
  additional_user_defined_string          = var.additional_user_defined_string
  parent                                  = var.parent
  billing_account                         = var.billing_account
  tf_service_account_email                = var.tf_service_account_email
  labels                                  = var.projectlabels
  services                                = var.project_services
  additional_user_defined_logging_metrics = var.additional_user_defined_logging_metrics
}

module "simple_central_logging" {
  source                         = "./modules/simple_central_logging"
  project_id                     = module.logging_center_project.project_id
  location                       = var.location
  customer_managed_key_id        = module.logging_center_project.default_regional_customer_managed_key_id
  log_bucket_viewer_members_list = var.log_bucket_viewer_members_list
  simple_central_log_bucket      = var.simple_central_log_bucket
  bucket_log_bucket              = var.bucket_log_bucket
}
