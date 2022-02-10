/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "service_account_email" {
  value = module.landing_zone_bootstrap.service_account_email
}

output "tfstate_bucket_names" {
  value = { for name, bucket in module.landing_zone_bootstrap.tfstate_bucket_names :
    name => bucket
  }
}

output "project_id" {
  value = module.landing_zone_bootstrap.project_id
}

output "organization_config" {
  value = var.organization_config
}

output "csr_name" {
  value = var.bootstrap.cloud_source_repo_name
}

output "terraform_deployment_account" {
  value = module.landing_zone_bootstrap.service_account_email
}
