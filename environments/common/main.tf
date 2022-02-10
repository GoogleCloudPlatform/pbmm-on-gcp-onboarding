/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/
###############################################################################
#                        Terraform top-level resources                        #
###############################################################################

module "access-context-manager" {
  source              = "../../modules/vpc-service-controls"
  parent_id           = local.organization_config.org_id
  policy_name         = var.access_context_manager.policy_name
  policy_id           = var.access_context_manager.policy_id
  access_level        = var.access_context_manager.access_level
  department_code     = local.organization_config.department_code
  environment         = local.organization_config.environment
  location            = local.organization_config.default_region
  user_defined_string = var.access_context_manager.user_defined_string
}


module "core-audit-bunker" {
  source                         = "../../modules/audit-bunker"
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  billing_account                = var.audit.billing_account
  parent                         = module.core-folders.folders_map_1_level["Audit"].id
  audit_streams                  = var.audit.audit_streams
  org_id                         = local.organization_config.org_id
  region                         = local.organization_config.default_region
  labels                         = var.audit.audit_labels
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  owner                          = local.organization_config.owner
  user_defined_string            = var.audit.user_defined_string
  additional_user_defined_string = var.audit.additional_user_defined_string
  bucket_name                    = var.audit.audit_streams.prod.bucket_name
  is_locked                      = var.audit.audit_streams.prod.is_locked
  bucket_force_destroy           = var.audit.audit_streams.prod.bucket_force_destroy
  bucket_storage_class           = var.audit.audit_streams.prod.bucket_storage_class
  sink_name                      = var.audit.audit_streams.prod.sink_name
  description                    = var.audit.audit_streams.prod.description
  filter                         = var.audit.audit_streams.prod.filter
  retention_period               = var.audit.audit_streams.prod.retention_period

  depends_on = [
    module.core-folders
  ]
}

module "core-folders" {
  source                  = "../../modules/folder"
  parent                  = var.folders.parent
  names                   = var.folders.names
  subfolders_first_level  = var.folders.subfolders_1
  subfolders_second_level = var.folders.subfolders_2
}

module "core-iam" {
  source           = "../../modules/iam"
  sa_create_assign = var.service_accounts
  project_iam      = local.audit_project_iam
  folder_iam       = local.folder_iam
  organization_iam = var.organization_iam
  organization     = local.organization_config.org_id
  depends_on = [
    module.core-org-custom-roles,
    module.core-folders
  ]
}

module "core-org-custom-roles" {
  source              = "../../modules/org-custom-roles"
  org_id              = local.organization_config.org_id
  custom_roles        = var.custom_roles
  department_code     = local.organization_config.department_code
  environment         = local.organization_config.environment
  location            = local.organization_config.default_region
  user_defined_string = var.audit.user_defined_string
}

module "core-org-policy" {
  source                       = "../../modules/organization-policy"
  organization_id              = local.organization_config.org_id
  directory_customer_id        = var.org_policies.directory_customer_id
  vms_allowed_with_external_ip = var.org_policies.vmAllowedWithExternalIp
  vms_allowed_with_ip_forward  = var.org_policies.vmAllowedWithIpForward
  policy_boolean               = var.org_policies.policy_boolean
  policy_list                  = var.org_policies.policy_list
  set_default_policy           = var.org_policies.setDefaultPolicy
}


module "core-guardrails" {
  source              = "../../modules/guardrails"
  parent              = module.core-folders.folders_map_1_level["Security"].id
  org_id              = local.organization_config.org_id
  billing_account     = local.organization_config.billing_account
  org_id_scan_list    = var.guardrails.org_id_scan_list
  org_client          = var.guardrails.org_client
  region              = local.organization_config.default_region
  user_defined_string = var.guardrails.user_defined_string
  department_code     = local.organization_config.department_code
  environment         = local.organization_config.environment
  owner               = local.organization_config.owner
  sa_enable_impersonation = true
  terraform_sa_email      = { sa = data.terraform_remote_state.bootstrap.outputs.service_account_email }
  terraform_sa_project    = data.terraform_remote_state.bootstrap.outputs.project_id
}
