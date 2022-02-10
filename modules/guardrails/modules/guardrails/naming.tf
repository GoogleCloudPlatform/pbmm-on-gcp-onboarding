/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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