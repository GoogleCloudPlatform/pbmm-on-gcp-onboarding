/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "service_accounts" {
  value = module.iam.service_accounts
}

output "project_iam_members" {
  value = module.iam.project_iam_members
}

output "compute_network_users" {
  value = module.iam.compute_network_users
}

output "folder_iam_members" {
  value = module.iam.folder_iam_members
}

output "organization_iam_members" {
  value = module.organization_iam.organization_iam_members
}

