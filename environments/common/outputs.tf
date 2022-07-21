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