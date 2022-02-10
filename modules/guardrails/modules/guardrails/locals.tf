/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  suffixes = {
    asset_inventory_suffix         = "assets"
    asset_inventory_reports_suffix = "reports"
  }
  cloud_artifact_registry = {
    default_artifact_registry_name = lower(module.guardrails_artifact_registry_name.result)
  }
  cloud_build = {
    default_container_build_pipeline_name = module.guardrails_container_build_pipeline_name.result
  }
  cloud_functions = {
    # name of subfolder found in ./functions folder that contains the cloud function code
    default_export_asset_inventory_function_folder_name = "gcf-guardrails-export-asset-inventory"
    default_export_asset_inventory_function_name        = module.export_asset_inventory_cf.result
    # name of subfolder found in ./functions folder that contains the cloud function code
    default_run_validation_function_folder_name = "gcf-guardrails-run-validation"
    default_run_validation_function_name        = module.run_validation_cf.result
  }
  cloud_source_repos = {
    default_policies_repo_name = module.guardrails_source_repo_name.result
  }
  cloud_storage = {
    default_cloud_functions_archives_bucket_name = module.guardrails_gcf_archives_bucket.result
    asset_inventory_bucket_name                  = module.guardrails_assets_bucket.result
    asset_inventory_reports_bucket_name          = module.guardrails_reports_bucket.result
  }
  cloud_scheduler = {
    default_cloud_scheduler_name = module.guardrails_scheduler_name.result
  }
  default_guardrails_service_account_name = module.guardrails_service_account_name.result
  guardrails_policies_container = {
    name = module.guardrails_policies_container_name.result
    tag  = "latest"
  }
}
