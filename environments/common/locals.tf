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
  organization_config = data.terraform_remote_state.bootstrap.outputs.organization_config

  folders_map          = module.core-folders.folders_map
  folders_map_1_level  = module.core-folders.folders_map_1_level
  folders_map_2_levels = module.core-folders.folders_map_2_levels

  folder_iam = [
    for fdiam in var.folder_iam : merge(fdiam, { folder = lookup(local.folders_map, fdiam.folder_name, lookup(local.folders_map_1_level, fdiam.folder_name, lookup(local.folders_map_2_levels, fdiam.folder_name, { name = fdiam.folder_name }))).name })
  ]

  audit_project_id = module.core-audit-bunker.project_id
  audit_project_iam = [
    for prj in var.audit_project_iam : merge(prj, { project = local.audit_project_id })
  ]

  guardrails_project_id = module.core-guardrails.project_id
  guardrails_project_iam = [
    for prj in var.guardrails_project_iam : merge(prj, { project = local.guardrails_project_id })
  ]

  project_iam = setunion(local.audit_project_iam, local.guardrails_project_iam)

  merged_logging_centers = {
    for key, lc in var.logging_centers : key => merge(lc, {
      central_log_bucket = merge(lc.central_log_bucket,
        lc.central_log_bucket.source_organization_sink != null ?
        {
          source_organization_sink = merge(lc.central_log_bucket.source_organization_sink, {
            organization_id = local.organization_config.org_id
          })
        } : {},
        lc.central_log_bucket.source_folder_sink != null ?
        {
          source_folder_sink = merge(lc.central_log_bucket.source_folder_sink, {
            folder = key == "dev-logging-center" ? module.core-folders.folders_map_1_level["Dev"].id : key == "uat-logging-center" ? module.core-folders.folders_map_1_level["UAT"].id : key == "prod-logging-center" ? module.core-folders.folders_map_1_level["Prod"].id : ""
          })
        } : {},
        lc.central_log_bucket.exporting_project_sink != null ?
        {
          exporting_project_sink = merge(lc.central_log_bucket.exporting_project_sink, {
            destination_project = local.audit_project_id
          })
        } : {}
      )
    })
  }

  monitoring_center_project_map = {
    organization-monitoring-center = module.core-logging-centers["organization-logging-center"].logging_center_project_id
    dev-monitoring-center          = module.core-logging-centers["dev-logging-center"].logging_center_project_id
    uat-monitoring-center          = module.core-logging-centers["uat-logging-center"].logging_center_project_id
    prod-monitoring-center         = module.core-logging-centers["prod-logging-center"].logging_center_project_id
  }

  # Only for monitoring centers without support to log-based metrics.
  # monitored_project_map = {
  #   organization-monitoring-center = null
  #   dev-monitoring-center          = null
  #   uat-monitoring-center          = null
  #   prod-monitoring-center         = null
  # }

  monitored_project_search_filter_map = {
    dev-monitoring-center  = "parent.type:folder parent.id:${module.core-folders.folders_map_1_level["Dev"].folder_id} lifecycleState:active"
    uat-monitoring-center  = "parent.type:folder parent.id:${module.core-folders.folders_map_1_level["UAT"].folder_id} lifecycleState:active"
    prod-monitoring-center = "parent.type:folder parent.id:${module.core-folders.folders_map_1_level["Prod"].folder_id} lifecycleState:active"
  }

  monitoring_center_monitored_project_map = {
    organization-monitoring-center = data.terraform_remote_state.bootstrap.outputs.organization_active_projects.projects
  }

  merged_monitoring_centers = {
    for key, mc in var.monitoring_centers : key => merge(mc, {
      project            = lookup(local.monitoring_center_project_map, key, "")
      monitored_projects = lookup(local.monitoring_center_monitored_project_map, key, [])
    })
  }
}
