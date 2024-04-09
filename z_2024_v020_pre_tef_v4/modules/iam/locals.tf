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


# locals {
#   sa_create_assign = defaults(var.sa_create_assign, {
#     project = var.project
#   })
#   project_iam = defaults(var.project_iam, {
#     project = var.project
#   })
#   compute_network_users = defaults(var.compute_network_users, {
#     project = var.project
#   })
#   organization_iam = defaults(var.organization_iam, {
#     organization = var.organization
#   })
# }

locals {
  sa_create_assign = tomap({
    for i in var.sa_create_assign : i.account_id => i
  })
  project_iam = tomap({
    for i in var.project_iam : format("%s/%s", i.project, i.member) => i
  })
  compute_network_users = tomap({
    for i in var.compute_network_users : i.subnetwork => i
  })
  organization_iam = tomap({
    for i in var.organization_iam : i.member => i
  })
}
