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
  id           = "opsadmin@DOMAIN_NAME"
  display_name = "opsadmin"
  description  = "ops admin group"
  domain       = "DOMAIN_NAME"
  #owners       = ["root@DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@DOMAIN_NAME"]
  members      = ["root@DOMAIN_NAME", "developer@DOMAIN_NAME"]
}

iam-group_networkadmin = {
  id           = "networkadmin@DOMAIN_NAME"
  display_name = "networkadmin"
  description  = "network admin group"
  domain       = "DOMAIN_NAME"
  #owners       = ["root@DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@DOMAIN_NAME"]
  members      = ["root@DOMAIN_NAME", "developer@DOMAIN_NAME"]
}

iam-group_telcoadmin = {
  id           = "telcoadmin@DOMAIN_NAME"
  display_name = "telcoadmin"
  description  = "telco admin group"
  domain       = "DOMAIN_NAME"
  #owners       = ["root@DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@DOMAIN_NAME"]
  members      = ["root@DOMAIN_NAME", "developer@DOMAIN_NAME"]
}


iam-group_secadmin = {
  id           = "secadmin@DOMAIN_NAME"
  display_name = "secadmin"
  description  = "security admin group"
  domain       = "DOMAIN_NAME"
  #owners       = ["root@DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@DOMAIN_NAME"]
  members      = ["root@DOMAIN_NAME", "developer@DOMAIN_NAME"]
}

iam-group_read = {
  id           = "read@DOMAIN_NAME"
  display_name = "read"
  description  = "read group"
  domain       = "DOMAIN_NAME"
  #owners       = ["root@DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@DOMAIN_NAME"]
  members      = ["developer@DOMAIN_NAME"]
}

iam-group_billing = {
  id           = "billing@DOMAIN_NAME"
  display_name = "billing"
  description  = "billing group"
  domain       = "DOMAIN_NAME"
  #owners       = ["root@DOMAIN_NAME"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@DOMAIN_NAME"]
  members      = ["developer@DOMAIN_NAME"]
}

organization_iam_group_secadmin = [
  {
    member       = "group:secadmin@DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_networkadmin = [
  {
    member       = "group:networkadmin@DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_telcoadmin = [
  {
    member       = "group:telcoadmin@DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_read = [
  {
    member       = "group:read@DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_billing = [
  {
    member       = "group:billing@DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_opsadmin = [
  {
    member       = "group:opsadmin@DOMAIN_NAME" # REQUIRED EDIT. group:user@google.com
    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
   roles = [
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
