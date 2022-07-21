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



locals {
  audit_project_id = module.core-audit-bunker.project_id
  audit_project_iam = [
    for prj in var.audit_project_iam : merge(prj, { project = local.audit_project_id })
  ]

  audit_folder_id = module.core-folders.folders_map_1_level[var.folder_iam[0].audit_folder_name].id
  folder_iam = [
    for prjf in var.folder_iam : merge(prjf, { folder = local.audit_folder_id })
  ]

  organization_config = data.terraform_remote_state.bootstrap.outputs.organization_config
}