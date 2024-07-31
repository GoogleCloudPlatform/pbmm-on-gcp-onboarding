/**
 * Copyright 2023 Google LLC
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

//org_id = "000000000000" # CHANGEME!!! format "000000000000"
//billing_account = "000000-000000-000000" # CHANGEME!!! format "000000-000000-000000"

// !!! anonymize if merging in public github, values here only for internat consumption (uncomment above, delete below)
org_id = "ORG_ID_REPLACE_ME" # CHANGEME!!! format "000000000000"
billing_account = "BILLING_ID_REPLACE_ME" # CHANGEME!!! format "000000-000000-000000"

groups = {
  # create_required_groups = false # Change to true to create the required_groups
  # create_optional_groups = false # Change to true to create the optional_groups
  # billing_project        =   # Fill to create required or optional groups
//  required_groups = {
//    group_org_admins           =  # example "gcp-organization-admins@example.com"
//    group_billing_admins       =  # example "gcp-billing-admins@example.com"
//    billing_data_users         =  # example "gcp-billing-data@example.com"
//    audit_data_users           =  # example "gcp-audit-data@example.com"
//    monitoring_workspace_users =  # example "gcp-monitoring-workspace@example.com"
//  }
// !!! anonymize if merging in public github, values here only for internat consumption (uncomment above, delete below)
  required_groups = {
    group_org_admins           = "gcp-org-admins@gcp.mcn.gouv.qc.ca"
    group_billing_admins       = "gcp-billing-admins@gcp.mcn.gouv.qc.ca"
    billing_data_users         = "gcp-billing-data-users@gcp.mcn.gouv.qc.ca"
    audit_data_users           = "gcp-audit-data-users@gcp.mcn.gouv.qc.ca"
    monitoring_workspace_users = "gcp-monitoring-workspace-users@gcp.mcn.gouv.qc.ca"
  }
  # optional_groups = {
  #   gcp_security_reviewer      = "" #"gcp_security_reviewer_local_test@example.com"
  #   gcp_network_viewer         = "" #"gcp_network_viewer_local_test@example.com"
  #   gcp_scc_admin              = "" #"gcp_scc_admin_local_test@example.com"
  #   gcp_global_secrets_admin   = "" #"gcp_global_secrets_admin_local_test@example.com"
  #   gcp_kms_admin              = "" #"gcp_kms_admin_local_test@example.com"
  # }
}

default_region = "DEFAULT_REGION_REPLACE_ME"
//default_region = "northamerica-northeast2"

# Optional - for an organization with existing projects or for development/validation.
# Uncomment this variable to place all the example foundation resources under
# the provided folder instead of the root organization.
# The variable value is the numeric folder ID
# The folder must already exist.
parent_folder = "PARENT_FOLDER_REPLACE_ME"

# modifier pour test

// by default 'restricted' not enabled and nothing 'restricted' is deployed
restricted_enabled = false
// Enable management spoke
management_enabled = true
// Enable identity spoke
identity_enabled = true
