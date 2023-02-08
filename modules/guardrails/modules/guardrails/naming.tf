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



module "export_asset_inventory_cf" {
  source = "../../../naming-standard//modules/gcp/cloud_function"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "GuardrailsExportAssetInventory"
}

module "run_validation_cf" {
  source = "../../../naming-standard//modules/gcp/cloud_function"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "GuardrailsRunValidation"
}

module "guardrails_gcf_archives_bucket" {
  source = "../../../naming-standard//modules/gcp/storage"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "guardrailsgcfarchive${var.user_defined_string}"
}

module "guardrails_assets_bucket" {
  source = "../../../naming-standard//modules/gcp/storage"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "${var.org_id}${local.suffixes.asset_inventory_suffix}${var.user_defined_string}"
}

module "guardrails_reports_bucket" {
  source = "../../../naming-standard//modules/gcp/storage"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "${var.org_id}${local.suffixes.asset_inventory_reports_suffix}${var.user_defined_string}"
}

module "guardrails_container_build_pipeline_name" {
  source = "../../../naming-standard//modules/gcp/cloudbuild_trigger"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "GuardrailsBuildDocker"
}

module "guardrails_scheduler_name" {
  source = "../../../naming-standard//modules/gcp/cloud_scheduler_job"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "TriggerAssetInventoryExport"
}

module "guardrails_service_account_name" {
  source = "../../../naming-standard//modules/gcp/service_account"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "guardrails"
}

module "guardrails_source_repo_name" {
  source = "../../../naming-standard//modules/gcp/generic_resource_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  resource_type       = "csr"
  device_type         = "CLD"
  user_defined_string = "guardrails-policies"
}

module "guardrails_artifact_registry_name" {
  source = "../../../naming-standard//modules/gcp/generic_resource_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  resource_type       = "afr"
  device_type         = "CLD"
  user_defined_string = "guardrails-af-registry"
}

module "guardrails_policies_container_name" {
  source = "../../../naming-standard//modules/gcp/container_registry_image"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = "guardrails-policies"
}