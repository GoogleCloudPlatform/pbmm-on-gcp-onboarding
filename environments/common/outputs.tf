/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "access_context_manager_policy_id" {
  value = module.access-context-manager.policy_id
}

output "access_context_manager_parent_id" {
  value = module.access-context-manager.parent_id
}

output "folders_map_2_levels" {
  value = module.core-folders.folders_map_2_levels
}

output "audit_config" {
  value = var.audit
}