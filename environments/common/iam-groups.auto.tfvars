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
/*
iam-groups = {
  id           = "security@terraform.landing.systems"
  display_name = "security"
  description  = "security group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["root@terraform.landing.systems", "developer@terraform.landing.systems"]
}*/

# when updating - recreate the entire group - authorative vs additive
iam-group_opsadmin = {
  id           = "opsadmin@terraform.landing.systems"
  display_name = "opsadmin"
  description  = "ops admin group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["root@terraform.landing.systems", "developer@terraform.landing.systems"]
}

iam-group_networkadmin = {
  id           = "networkadmin@terraform.landing.systems"
  display_name = "networkadmin"
  description  = "network admin group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["root@terraform.landing.systems", "developer@terraform.landing.systems"]
}

iam-group_telcoadmin = {
  id           = "telcoadmin@terraform.landing.systems"
  display_name = "telcoadmin"
  description  = "telco admin group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["root@terraform.landing.systems", "developer@terraform.landing.systems"]
}


iam-group_secadmin = {
  id           = "secadmin@terraform.landing.systems"
  display_name = "secadmin"
  description  = "security admin group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["root@terraform.landing.systems", "developer@terraform.landing.systems"]
}

iam-group_read = {
  id           = "read@terraform.landing.systems"
  display_name = "read"
  description  = "read group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["developer@terraform.landing.systems"]
}

iam-group_billing = {
  id           = "billing@terraform.landing.systems"
  display_name = "billing"
  description  = "billing group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"] # var.service_accounts
  #managers     = ["root@terraform.landing.systems"]
  members      = ["developer@terraform.landing.systems"]
}

organization_iam_groups = [
  {
    member       = "group:opsadmin@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }#,
   # {
   # member       = "group:prodbilling@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
   # organization = "131880894992" #Insert your Ord ID here, format ############
   # roles = [
   #   "roles/viewer",
   # ]
  #}
]

organization_iam_group_secadmin = [
  {
    member       = "group:secadmin@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_networkadmin = [
  {
    member       = "group:networkadmin@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_telcoadmin = [
  {
    member       = "group:telcoadmin@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_read = [
  {
    member       = "group:read@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_billing = [
  {
    member       = "group:billing@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]

organization_iam_group_opsadmin = [
  {
    member       = "group:opsadmin@terraform.landing.systems" # REQUIRED EDIT. group:user@google.com
    organization = "131880894992" #Insert your Ord ID here, format ############
    roles = [
      "roles/viewer",
    ]
  }
]
