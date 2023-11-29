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


###############################################################################
#                        Production Network                                   #
###############################################################################



module "prod-client-prj" {
  source                         = "../../modules/project"
  department_code                = local.organization_config.department_code
  user_defined_string            = var.prod_workload_net.user_defined_string
  additional_user_defined_string = var.prod_workload_net.additional_user_defined_string
  labels                         = var.prod_workload_net.labels
  owner                          = local.organization_config.owner
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  billing_account                = local.organization_config.billing_account
  parent                         = data.terraform_remote_state.common.outputs.folders_map_1_levels.Prod.id
  services                       = var.prod_workload_net.services
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  # mutually exclusive
  shared_vpc_host_config         = false
    shared_vpc_service_config = {
    attach       = true
    host_project = module.net-host-prj.project_id 
  }

  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj
  ] 
}

# https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/latest
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = module.net-host-prj.project_id 
  prefix        = "bigquery"
  names         = ["sa"]#, "second"]
  #project_roles = [
  #  "roles/bigquery.admin"#,
    #"module.net-host-prj.project_id=>roles/bigquery.admin"#,
  #]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam.html#google_project_iam_binding


/*
module "prod-iam" {
  source           = "../../modules/iam"
  sa_create_assign = var.service_accounts
  project_iam      = var.prod_services_project_iam
  folder_iam       = local.folder_iam
  organization_iam = var.organization_iam
  organization     = local.organization_config.org_id
  depends_on = [
    module.core-org-custom-roles,
    module.core-folders
  ]
}*/

/*
resource "google_project_iam_binding" "prod-client-prj-binding" {
  project = module.prod-client-prj.project_id
  role    = "roles/owner"

  members = [
    "user:developer@terraform.landing.systems",
  ]
  depends_on = [
    data.terraform_remote_state.common,
    module.prod-client-prj
  ] 
}*/