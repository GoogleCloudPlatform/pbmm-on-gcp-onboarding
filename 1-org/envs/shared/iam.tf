/**
 * Copyright 2021 Google LLC
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

/******************************************
  Audit Logs - IAM
*****************************************/

locals {
  enabling_data_logs = var.data_access_logs_enabled ? ["DATA_WRITE", "DATA_READ"] : []
}

resource "google_organization_iam_audit_config" "org_config" {
  count   = local.parent_folder == "" ? 1 : 0
  org_id  = local.org_id
  service = "allServices"

  ###################################################################################################
  ### Audit logs can generate costs, to know more about it,
  ### check the official documentation: https://cloud.google.com/stackdriver/pricing#logging-costs
  ### To know more about audit logs, you can find more infos
  ### here https://cloud.google.com/logging/docs/audit/configure-data-access
  ### To enable DATA_READ and DATA_WRITE audit logs, set `data_access_logs_enabled` to true
  ### ADMIN_READ logs are enabled by default.
  ####################################################################################################
  dynamic "audit_log_config" {
    for_each = setunion(local.enabling_data_logs, ["ADMIN_READ"])
    content {
      log_type = audit_log_config.key
    }
  }
}

resource "google_folder_iam_audit_config" "folder_config" {
  count   = local.parent_folder != "" ? 1 : 0
  folder  = "folders/${local.parent_folder}"
  service = "allServices"

  ###################################################################################################
  ### Audit logs can generate costs, to know more about it,
  ### check the official documentation: https://cloud.google.com/stackdriver/pricing#logging-costs
  ### To know more about audit logs, you can find more infos
  ### here https://cloud.google.com/logging/docs/audit/configure-data-access
  ### To enable DATA_READ and DATA_WRITE audit logs, set `data_access_logs_enabled` to true
  ### ADMIN_READ logs are enabled by default.
  ####################################################################################################
  dynamic "audit_log_config" {
    for_each = setunion(local.enabling_data_logs, ["ADMIN_READ"])
    content {
      log_type = audit_log_config.key
    }
  }
}

resource "google_project_iam_member" "audit_log_bq_user" {
  project = module.org_audit_logs.project_id
  role    = "roles/bigquery.user"
  member  = "group:${var.audit_data_users}"
}

resource "google_project_iam_member" "audit_log_bq_data_viewer" {
  project = module.org_audit_logs.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.audit_data_users}"
}

/******************************************
  Billing BigQuery - IAM
*****************************************/

resource "google_project_iam_member" "billing_bq_user" {
  project = module.org_billing_logs.project_id
  role    = "roles/bigquery.user"
  member  = "group:${var.billing_data_users}"
}

resource "google_project_iam_member" "billing_bq_viewer" {
  project = module.org_billing_logs.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.billing_data_users}"
}

/******************************************
  Billing Cloud Console - IAM
*****************************************/

resource "google_organization_iam_member" "billing_viewer" {
  org_id = local.org_id
  role   = "roles/billing.viewer"
  member = "group:${var.billing_data_users}"
}

/******************************************
 Groups permissions according to SFB (Section 6.2 - Users and groups) - IAM
*****************************************/

resource "google_organization_iam_member" "organization_viewer" {
  count  = var.gcp_groups.platform_viewer != null && local.parent_folder == "" ? 1 : 0
  org_id = local.org_id
  role   = "roles/viewer"
  member = "group:${var.gcp_groups.platform_viewer}"
}

resource "google_folder_iam_member" "organization_viewer" {
  count  = var.gcp_groups.platform_viewer != null && local.parent_folder != "" ? 1 : 0
  folder = "folders/${local.parent_folder}"
  role   = "roles/viewer"
  member = "group:${var.gcp_groups.platform_viewer}"
}

resource "google_organization_iam_member" "security_reviewer" {
  count  = var.gcp_groups.security_reviewer != null && local.parent_folder == "" ? 1 : 0
  org_id = local.org_id
  role   = "roles/iam.securityReviewer"
  member = "group:${var.gcp_groups.security_reviewer}"
}

resource "google_folder_iam_member" "security_reviewer" {
  count  = var.gcp_groups.security_reviewer != null && local.parent_folder != "" ? 1 : 0
  folder = "folders/${local.parent_folder}"
  role   = "roles/iam.securityReviewer"
  member = "group:${var.gcp_groups.security_reviewer}"
}

resource "google_organization_iam_member" "network_viewer" {
  count  = var.gcp_groups.network_viewer != null && local.parent_folder == "" ? 1 : 0
  org_id = local.org_id
  role   = "roles/compute.networkViewer"
  member = "group:${var.gcp_groups.network_viewer}"
}

resource "google_folder_iam_member" "network_viewer" {
  count  = var.gcp_groups.network_viewer != null && local.parent_folder != "" ? 1 : 0
  folder = "folders/${local.parent_folder}"
  role   = "roles/compute.networkViewer"
  member = "group:${var.gcp_groups.network_viewer}"
}

resource "google_project_iam_member" "audit_log_viewer" {
  count   = var.gcp_groups.audit_viewer != null ? 1 : 0
  project = module.org_audit_logs.project_id
  role    = "roles/logging.viewer"
  member  = "group:${var.gcp_groups.audit_viewer}"
}

resource "google_project_iam_member" "audit_private_logviewer" {
  count   = var.gcp_groups.audit_viewer != null ? 1 : 0
  project = module.org_audit_logs.project_id
  role    = "roles/logging.privateLogViewer"
  member  = "group:${var.gcp_groups.audit_viewer}"
}

resource "google_project_iam_member" "audit_bq_data_viewer" {
  count   = var.gcp_groups.audit_viewer != null ? 1 : 0
  project = module.org_audit_logs.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.gcp_groups.audit_viewer}"
}

resource "google_project_iam_member" "scc_admin" {
  count   = var.gcp_groups.scc_admin != null ? 1 : 0
  project = module.scc_notifications.project_id
  role    = "roles/securitycenter.adminEditor"
  member  = "group:${var.gcp_groups.scc_admin}"
}

resource "google_project_iam_member" "global_secrets_admin" {
  count   = var.gcp_groups.global_secrets_admin != null ? 1 : 0
  project = module.org_secrets.project_id
  role    = "roles/secretmanager.admin"
  member  = "group:${var.gcp_groups.global_secrets_admin}"
}

/******************************************
 Privileged accounts permissions according to SFB (Section 6.3 - Privileged identities)
*****************************************/

resource "google_organization_iam_member" "org_admin_user" {
  count  = var.gcp_user.org_admin != null && local.parent_folder == "" ? 1 : 0
  org_id = local.org_id
  role   = "roles/resourcemanager.organizationAdmin"
  member = "user:${var.gcp_user.org_admin}"
}

resource "google_folder_iam_member" "org_admin_user" {
  count  = var.gcp_user.org_admin != null && local.parent_folder != "" ? 1 : 0
  folder = "folders/${local.parent_folder}"
  role   = "roles/resourcemanager.folderAdmin"
  member = "user:${var.gcp_user.org_admin}"
}

resource "google_organization_iam_member" "billing_creator_user" {
  count  = var.gcp_user.billing_creator != null && local.parent_folder == "" ? 1 : 0
  org_id = local.org_id
  role   = "roles/billing.creator"
  member = "user:${var.gcp_user.billing_creator}"
}

resource "google_billing_account_iam_member" "billing_admin_user" {
  count              = var.gcp_user.billing_admin != null ? 1 : 0
  billing_account_id = local.billing_account
  role               = "roles/billing.admin"
  member             = "user:${var.gcp_user.billing_admin}"
}
