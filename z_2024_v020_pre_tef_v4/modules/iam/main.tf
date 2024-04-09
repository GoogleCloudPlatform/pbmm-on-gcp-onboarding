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

module "sa_create_assign" {
  source = "./modules/sa_create_assign"

  for_each                = { for sa in local.sa_create_assign : sa.account_id => sa }
  project                 = each.value.project
  account_id              = each.value.account_id
  display_name            = each.value.display_name
  roles                   = each.value.roles
  custom_role_name_id_map = var.custom_role_name_id_map
}

module "project_iam" {
  source = "./modules/project_iam"

  for_each                = { for account in local.project_iam : format("%s/%s", account.project, account.member) => account }
  project                 = each.value.project
  member                  = each.value.member
  roles                   = each.value.roles
  custom_role_name_id_map = var.custom_role_name_id_map
}

module "compute_network_users" {
  source = "./modules/compute_network_user"

  for_each   = { for subnet in local.compute_network_users : subnet.subnetwork => subnet }
  project    = each.value.project
  region     = each.value.region
  subnetwork = each.value.subnetwork
  members    = each.value.members
}

module "folder_iam" {
  source = "./modules/folder_iam"
  count  = length(var.folder_iam)
  #for_each = { for folder in var.folder_iam : format("%s-%s", folder.folder, folder.member) => folder }
  folder                  = var.folder_iam[count.index].folder
  member                  = var.folder_iam[count.index].member
  roles                   = var.folder_iam[count.index].roles
  custom_role_name_id_map = var.custom_role_name_id_map
}

module "organization_iam" {
  source = "./modules/organization_iam"

  for_each                = { for account in local.organization_iam : account.member => account }
  organization            = each.value.organization
  member                  = each.value.member
  roles                   = each.value.roles
  custom_role_name_id_map = var.custom_role_name_id_map
}
