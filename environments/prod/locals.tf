/**
 * Copyright 2022 Google LLC
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

locals {
  organization_config = data.terraform_remote_state.bootstrap.outputs.organization_config
  net_host_prj_id     = module.net-host-prj.project_id

  /*monitoring_center_project_map = data.terraform_remote_state.common.outputs.monitoring_center_projects
  monitoring_center_monitored_project_map = {
    for k, v in data.terraform_remote_state.common.outputs.monitored_projects : k => v.projects
  }
  merged_monitoring_centers = {
    for key, mc in var.monitoring_centers : key => merge(mc, {
      project            = lookup(local.monitoring_center_project_map, key, "")
      monitored_projects = lookup(local.monitoring_center_monitored_project_map, key, [])
    })
  }*/

  prod_projects = [
    for prj in var.prod_projects : merge(prj, {
      name = join("-", [prj.user_defined_string, prj.additional_user_defined_string])
      shared_vpc_service_config = {
        attach       = prj.shared_vpc_service_config.attach,
        host_project = prj.shared_vpc_service_config.host_project == "net-host-prj" ? local.net_host_prj_id : prj.shared_vpc_service_config.host_project
    } })
  ]

  #Adding the net host project to the vpc controls list
  prod_vpc_svc_ctl = {
    for perim_type, svcperim in var.prod_vpc_svc_ctl : perim_type => {
      for prj, attrs in svcperim : prj => merge(
        {
          for attr, val in attrs : attr => val if attr != "resources"
        },
        {
          # if this block from line 10 is uncommented - comment below for resources until the following issue is resolved
          # https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/40
#          resources = distinct(concat(attrs.resources, [module.net-host-prj.project_id]))
        }
      )
    }
  }
}
