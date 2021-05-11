/**
 * Copyright 2021 Google LLC
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




module "service-project" {
  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"

  name              = var.service_project_name
  random_project_id = false

  org_id          = var.parent_id
#CHANGE Folder id based on foldee the project is created under
  folder_id       = "${module.DeptEnvProtectedB.id}"
  billing_account = var.billing_account
# Change shared vpc  and subnet based on host project to attach to
  shared_vpc         = module.host-project.project_id
  shared_vpc_subnets = module.vpc.subnets_self_links

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dataproc.googleapis.com",
    "dataflow.googleapis.com",
  ]

  disable_services_on_destroy = false
}

