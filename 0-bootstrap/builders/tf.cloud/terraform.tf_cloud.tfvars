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

org_id = "REPLACE_ME" # format "000000000000"

billing_account = "REPLACE_ME" # format "000000-000000-000000"

// For enabling the automatic groups creation, uncoment the
// variables and update the values with the group names
groups = {
  # create_required_groups = false # Change to true to create the required_groups
  # create_optional_groups = false # Change to true to create the optional_groups
  # billing_project        = "REPLACE_ME"  # Fill to create required or optional groups
  required_groups = {
    group_org_admins           = "REPLACE_ME" # example "gcp-organization-admins@example.com"
    group_billing_admins       = "REPLACE_ME" # example "gcp-billing-admins@example.com"
    billing_data_users         = "REPLACE_ME" # example "gcp-billing-data@example.com"
    audit_data_users           = "REPLACE_ME" # example "gcp-audit-data@example.com"
    monitoring_workspace_users = "REPLACE_ME" # example "gcp-monitoring-workspace@example.com"
  }
  # optional_groups = {
  #   gcp_security_reviewer      = "" #"gcp_security_reviewer_local_test@example.com"
  #   gcp_network_viewer         = "" #"gcp_network_viewer_local_test@example.com"
  #   gcp_scc_admin              = "" #"gcp_scc_admin_local_test@example.com"
  #   gcp_global_secrets_admin   = "" #"gcp_global_secrets_admin_local_test@example.com"
  #   gcp_kms_admin              = "" #"gcp_kms_admin_local_test@example.com"
  # }
}

default_region = "us-central1"

# Optional - for an organization with existing projects or for development/validation.
# Uncomment this variable to place all the example foundation resources under
# the provided folder instead of the root organization.
# The variable value is the numeric folder ID
# The folder must already exist.
# parent_folder = "01234567890"




/* ----------------------------------------
    Specific to tfc_bootstrap
   ---------------------------------------- */
//  Un-comment tfc_bootstrap and its outputs if you want to use Terraform Cloud instead of Cloud Build
// Format expected: REPO-OWNER/REPO-NAME
vcs_repos = {
  owner        = "YOUR-VCS-USER-OR-ORGANIZATION",
  bootstrap    = "YOUR-BOOTSTRAP-REPOSITORY",
  organization = "YOUR-ORGANIZATION-REPOSITORY",
  environments = "YOUR-ENVIRONMENTS-REPOSITORY",
  networks     = "YOUR-NETWORKS-REPOSITORY",
  projects     = "YOUR-PROJECTS-REPOSITORY",
}
tfc_org_name = "REPLACE_ME"

// Set this to true if you want to use Terraform Cloud Agents instead of Terraform Cloud remote runner
// If true, a private Autopilot GKE cluster will be created in your GCP account to be used as Terraform Cloud Agents
// More info about Agents on: https://developer.hashicorp.com/terraform/cloud-docs/agents

# enable_tfc_cloud_agents = false

//  to prevent saving the `tfc_token` in plain text in this file,
//  export the Terraform Cloud token in the command line
//  as an environment variable before running terraform.
//  Run the following commnad in your shell:
# export TF_VAR_tfc_token="YOUR-TFC-TOKEN"

//  For VCS connection based in OAuth: (GitHub OAuth/GitHub Enterprise/Gitlab.com/GitLab Enterprise or Community Edition)
//  to prevent saving the `vcs_oauth_token_id` in plain text in this file,
//  export the Terraform Cloud VCS Connection OAuth token ID in the command line
//  as an environment variable before running terraform.

// Note: you should be able to copy `OAuth Token ID` (vcs_oauth_token_id) in TFC console:
// https://app.terraform.io/app/YOUR-TFC-ORGANIZATION/settings/version-control

//  Run the following commnad in your shell:
#  export TF_VAR_vcs_oauth_token_id="YOUR-VCS-OAUTH-TOKEN-ID"

//  For GitHub OAuth see: https://developer.hashicorp.com/terraform/cloud-docs/vcs/github
//  For GitHub Enterprise see: https://developer.hashicorp.com/terraform/cloud-docs/vcs/github-enterprise
//  For GitLab.com see: https://developer.hashicorp.com/terraform/cloud-docs/vcs/gitlab-com
//  For GitLab EE/CE see: https://developer.hashicorp.com/terraform/cloud-docs/vcs/gitlab-eece
