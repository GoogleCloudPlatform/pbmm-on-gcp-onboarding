/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "tfstate_bucket_names" {
  value = module.bootstrap_project.tfstate_bucket_names
}

output "project_id" {
  value = module.bootstrap_project.project_id
}

output "service_account_email" {
  value = module.bootstrap_project.service_account_email
}

output "yaml_config_bucket" {
  value = module.bootstrap_project.yaml_config_bucket
}