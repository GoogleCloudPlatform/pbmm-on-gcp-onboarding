/**
 * Copyright 2021 Google LLC
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
module "floating_project_base" {
  source = "../single_project"
  count = (
    try(var.float_project_config != null &&
    contains(keys(var.float_project_config), "project_type"), false) &&
    var.float_project_config.project_type == "float" &&
    contains(keys(var.float_project_config), "base") &&
  try(var.float_project_config.base != null, false)) ? 1 : 0

  org_id          = local.org_id
  billing_account = local.billing_account
  environment     = var.env
  project_budget  = var.project_budget
  project_prefix  = local.project_prefix

  # Metadata
  project_suffix    = "-b-${lower(replace(substr(var.float_project_config.base.project_id, length(var.float_project_config.base.project_id) - 6, 6), "_", "-"))}"
  application_name  = "${var.business_code}-${var.float_project_config.base.project_app}"
  billing_code      = var.float_project_config.billing_code
  primary_contact   = var.float_project_config.primary_contact
  secondary_contact = var.float_project_config.secondary_contact
  business_code     = var.business_code
  folder_id         = var.float_project_config.folder_id
  vpc_type          = "base"
}

module "floating_project_restricted" {
  source = "../single_project"
  count = (
    try(var.float_project_config != null &&
    contains(keys(var.float_project_config), "project_type"), false) &&
    var.float_project_config.project_type == "float" &&
    contains(keys(var.float_project_config), "restricted") &&
  try(var.float_project_config.restricted != null, false)) ? 1 : 0

  org_id          = local.org_id
  billing_account = local.billing_account
  environment     = var.env
  project_budget  = var.project_budget
  project_prefix  = local.project_prefix

  # Metadata
  project_suffix    = "-r-${lower(replace(substr(var.float_project_config.restricted.project_id, length(var.float_project_config.restricted.project_id) - 6, 6), "_", "-"))}"
  application_name  = "${var.business_code}-${var.float_project_config.restricted.project_app}"
  billing_code      = var.float_project_config.billing_code
  primary_contact   = var.float_project_config.primary_contact
  secondary_contact = var.float_project_config.secondary_contact
  business_code     = var.business_code
  folder_id         = var.float_project_config.folder_id
  vpc_type          = "restricted"

}
