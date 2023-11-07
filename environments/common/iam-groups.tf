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



# https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/271
# the terraform service account must be added in admin.google.com as a groups admin
# https://admin.google.com/ac/roles/58150197607268354
# move to common
module "group_opsadmin" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-group_opsadmin.id
  display_name = var.iam-group_opsadmin.display_name
  description  = var.iam-group_opsadmin.description
  domain       = var.iam-group_opsadmin.domain
  #owners       = var.iam-group_opsadmin.owners
  #managers     = var.iam-group_opsadmin.managers
  members      = var.iam-group_opsadmin.members
}

module "group_secadmin" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-group_secadmin.id
  display_name = var.iam-group_secadmin.display_name
  description  = var.iam-group_secadmin.description
  domain       = var.iam-group_secadmin.domain
  #owners       = var.iam-group_secadmin.owners
  #managers     = var.iam-group_secadmin.managers
  members      = var.iam-group_secadmin.members
}

module "group_telcoadmin" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-group_telcoadmin.id
  display_name = var.iam-group_telcoadmin.display_name
  description  = var.iam-group_telcoadmin.description
  domain       = var.iam-group_telcoadmin.domain
  #owners       = var.iam-group_telcoadmin.owners
  #managers     = var.iam-group_telcoadmin.managers
  members      = var.iam-group_telcoadmin.members
}

module "group_read" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-group_read.id
  display_name = var.iam-group_read.display_name
  description  = var.iam-group_read.description
  domain       = var.iam-group_read.domain
  #owners       = var.iam-group_read.owners
  #managers     = var.iam-group_read.managers
  members      = var.iam-group_read.members
}

module "group_billing" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-group_billing.id
  display_name = var.iam-group_billing.display_name
  description  = var.iam-group_billing.description
  domain       = var.iam-group_billing.domain
  #owners       = var.iam-group_billing.owners
  #managers     = var.iam-group_billing.managers
  members      = var.iam-group_billing.members
}

module "group_networkadmin" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-group_networkadmin.id
  display_name = var.iam-group_networkadmin.display_name
  description  = var.iam-group_networkadmin.description
  domain       = var.iam-group_networkadmin.domain
  #owners       = var.iam-group_networkadmin.owners
  #managers     = var.iam-group_networkadmin.managers
  members      = var.iam-group_networkadmin.members
}

module "iam-groups-role_opsadmin" {
  source           = "../../modules/iam"
  #sa_create_assign = var.iam-groups.id #var.service_accounts
  #project_iam      = local.project_iam
  #folder_iam       = local.folder_iam
  organization_iam = var.organization_iam_group_opsadmin
  organization     = local.organization_config.org_id
  depends_on = [
    module.group_opsadmin#,
    #module.core-org-custom-roles,
    #module.core-folders
  ]
}

module "iam-groups-role_networkadmin" {
  source           = "../../modules/iam"
  #sa_create_assign = var.iam-groups.id #var.service_accounts
  #project_iam      = local.project_iam
  #folder_iam       = local.folder_iam
  organization_iam = var.organization_iam_group_networkadmin
  organization     = local.organization_config.org_id
  depends_on = [
    module.group_networkadmin#,
    #module.core-org-custom-roles,
    #module.core-folders
  ]
}

module "iam-groups-role_secadmin" {
  source           = "../../modules/iam"
  #sa_create_assign = var.iam-groups.id #var.service_accounts
  #project_iam      = local.project_iam
  #folder_iam       = local.folder_iam
  organization_iam = var.organization_iam_group_secadmin
  organization     = local.organization_config.org_id
  depends_on = [
    module.group_secadmin#,
    #module.core-org-custom-roles,
    #module.core-folders
  ]
}

module "iam-groups-role_telcoadmin" {
  source           = "../../modules/iam"
  #sa_create_assign = var.iam-groups.id #var.service_accounts
  #project_iam      = local.project_iam
  #folder_iam       = local.folder_iam
  organization_iam = var.organization_iam_group_telcoadmin
  organization     = local.organization_config.org_id
  depends_on = [
    module.group_telcoadmin#,
    #module.core-org-custom-roles,
    #module.core-folders
  ]
}

module "iam-groups-role_read" {
  source           = "../../modules/iam"
  #sa_create_assign = var.iam-groups.id #var.service_accounts
  #project_iam      = local.project_iam
  #folder_iam       = local.folder_iam
  organization_iam = var.organization_iam_group_read
  organization     = local.organization_config.org_id
  depends_on = [
    module.group_read#,
    #module.core-org-custom-roles,
    #module.core-folders
  ]
}

module "iam-groups-role_billing" {
  source           = "../../modules/iam"
  #sa_create_assign = var.iam-groups.id #var.service_accounts
  #project_iam      = local.project_iam
  #folder_iam       = local.folder_iam
  organization_iam = var.organization_iam_group_billing
  organization     = local.organization_config.org_id
  depends_on = [
    module.group_billing#,
    #module.core-org-custom-roles,
    #module.core-folders
  ]
}
