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

# when updating - recreate the entire group - authorative vs additive
iam-group_opsadmin = {
  id           = "opsadmin@REPLACE_DOMAIN_NAME"
  display_name = "opsadmin"
  description  = "ops admin group"
  domain       = "REPLACE_DOMAIN_NAME"
  #owners       = ["root@REPLACE_DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@REPLACE_DOMAIN_NAME"]
  members      = ["root@REPLACE_DOMAIN_NAME"]
}

iam-group_networkadmin = {
  id           = "networkadmin@REPLACE_DOMAIN_NAME"
  display_name = "networkadmin"
  description  = "network admin group"
  domain       = "REPLACE_DOMAIN_NAME"
  #owners       = ["root@REPLACE_DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@REPLACE_DOMAIN_NAME"]
  members      = ["root@REPLACE_DOMAIN_NAME", "developer@REPLACE_DOMAIN_NAME"]
}

iam-group_telcoadmin = {
  id           = "telcoadmin@REPLACE_DOMAIN_NAME"
  display_name = "telcoadmin"
  description  = "telco admin group"
  domain       = "REPLACE_DOMAIN_NAME"
  #owners       = ["root@REPLACE_DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@REPLACE_DOMAIN_NAME"]
  members      = ["root@REPLACE_DOMAIN_NAME", "developer@REPLACE_DOMAIN_NAME"]
}


iam-group_secadmin = {
  id           = "secadmin@REPLACE_DOMAIN_NAME"
  display_name = "secadmin"
  description  = "security admin group"
  domain       = "REPLACE_DOMAIN_NAME"
  #owners       = ["root@REPLACE_DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@REPLACE_DOMAIN_NAME"]
  members      = ["root@REPLACE_DOMAIN_NAME", "developer@REPLACE_DOMAIN_NAME"]
}

iam-group_read = {
  id           = "read@REPLACE_DOMAIN_NAME"
  display_name = "read"
  description  = "read group"
  domain       = "REPLACE_DOMAIN_NAME"
  #owners       = ["root@REPLACE_DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@REPLACE_DOMAIN_NAME"]
  members      = ["developer@REPLACE_DOMAIN_NAME"]
}

iam-group_billing = {
  id           = "billing@REPLACE_DOMAIN_NAME"
  display_name = "billing"
  description  = "billing group"
  domain       = "REPLACE_DOMAIN_NAME"
  #owners       = ["root@REPLACE_DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@REPLACE_DOMAIN_NAME"]
  members      = ["developer@REPLACE_DOMAIN_NAME"]
}

organization_iam_group_secadmin = [
  {
    member       = "group:secadmin@REPLACE_DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_networkadmin = [
  {
    member       = "group:networkadmin@REPLACE_DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_telcoadmin = [
  {
    member       = "group:telcoadmin@REPLACE_DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_read = [
  {
    member       = "group:read@REPLACE_DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
      "roles/bigquery.admin"
    ]
  }
]

organization_iam_group_billing = [
  {
    member       = "group:billing@REPLACE_DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_opsadmin = [
  {
    member       = "group:opsadmin@REPLACE_DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
   roles = [
      "roles/bigquery.admin",
"roles/iam.serviceAccountTokenCreator",
"roles/resourcemanager.folderAdmin",
"roles/resourcemanager.organizationAdmin",
"roles/orgpolicy.policyAdmin",
"roles/resourcemanager.projectCreator",
"roles/billing.projectManager",
"roles/cloudbuild.builds.builder",
"roles/cloudbuild.builds.editor",
"roles/editor",
"roles/secretmanager.secretAccessor",
"roles/source.admin",
"roles/storage.admin",
"roles/storage.objectViewer",
    ]
  }
]
