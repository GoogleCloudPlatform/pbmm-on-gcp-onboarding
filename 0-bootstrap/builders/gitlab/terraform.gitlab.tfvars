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
    Specific to gitlab_bootstrap
   ---------------------------------------- */
# Un-comment gitlab_bootstrap and its outputs if you want to use GitLab CI/CD instead of Cloud Build
gl_repos = {
    owner        = "YOUR-GITLAB-USER-OR-GROUP",
    bootstrap    = "YOUR-BOOTSTRAP-REPOSITORY",
    organization = "YOUR-ORGANIZATION-REPOSITORY",
    environments = "YOUR-ENVIRONMENTS-REPOSITORY",
    networks     = "YOUR-NETWORKS-REPOSITORY",
    projects     = "YOUR-PROJECTS-REPOSITORY",
    cicd_runner  = "YOUR-CICD-RUNNER-REPOSITORY",
}

#  to prevent saving the `gitlab_token` in plain text in this file,
#  export the GitLab access token in the command line
#  as an environment variable before running terraform.
#  Run the following commnad in your shell:
#   export TF_VAR_gitlab_token="YOUR-ACCESS-TOKEN"

