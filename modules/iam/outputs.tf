/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "service_accounts" {
  value = { for key, sa in module.sa_create_assign : key => sa.service_account }
}

output "project_iam_members" {
  value = [for _, account in module.project_iam : account.member]
}

output "compute_network_users" {
  value = [for _, account in module.compute_network_users : account.member]
}

output "folder_iam_members" {
  value = [for _, account in module.folder_iam : account.member]
}

output "organization_iam_members" {
  value = [for _, account in module.organization_iam : account.member]
}