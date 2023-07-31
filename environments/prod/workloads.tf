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
  parent                         = data.terraform_remote_state.common.outputs.folders_map_1_level.Prod.id
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
