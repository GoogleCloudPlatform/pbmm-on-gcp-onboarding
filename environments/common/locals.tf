/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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