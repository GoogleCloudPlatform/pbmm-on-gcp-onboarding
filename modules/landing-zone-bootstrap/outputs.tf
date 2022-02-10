/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "service_account_email" {
  value = google_service_account.org_terraform.email
}

output "tfstate_bucket_names" {
  value = { for name, bucket in google_storage_bucket.org_terraform_state :
    name => bucket.name
  }
}

output "project_id" {
  value = module.project.project_id
}
