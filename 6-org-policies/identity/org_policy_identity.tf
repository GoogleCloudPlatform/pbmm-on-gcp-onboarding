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

locals {
  list_i_prj_org_policy_requireShieldedVm_enforce = [
    local.prj_i_shared_restricted,
  ]

  list_prj_i_ntwrk_org_policy_override = [
    local.prj_i_shared_base,
  ]
}

module "org_policies_require_shielded_vm_i_enforce" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each = { for project_id in local.list_i_prj_org_policy_requireShieldedVm_enforce :
  project_id => project_id if project_id != null }
  constraint  = "constraints/compute.requireShieldedVm"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce = true
}

# Excluding network projects from the policy 
# For allowing Fortigate to pick image from a diiferent region.
module "org_policies_resource_location_constraint_identity_ntwrk_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = ">= 3.77" #"~> 3.0.2"

  for_each = { for project_id in local.list_prj_i_ntwrk_org_policy_override :
  project_id => project_id if project_id != null }  
  constraint  = "constraints/gcp.resourceLocations"
  policy_for  = "project"
  policy_type = "list"
  project_id  = each.value
  enforce     = false
}

module "org_policy_i_disableSerialPortAccess_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each = { for project_id in local.list_prj_i_ntwrk_org_policy_override :
  project_id => project_id if project_id != null }    
  constraint  = "constraints/compute.disableSerialPortAccess"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce     = false
}

module "org_policy_i_disableVpcExternalIpv6_prj_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  for_each = { for project_id in local.list_prj_i_ntwrk_org_policy_override :
  project_id => project_id if project_id != null }    
  constraint  = "constraints/compute.disableVpcExternalIpv6"
  policy_for  = "project"
  policy_type = "boolean"
  project_id  = each.value
  enforce     = false
}

module "org_vm_external_ip_access_identity_override" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  policy_for  = "project" # Can be "organization" or "folder"
  for_each = { for project_id in local.list_prj_i_ntwrk_org_policy_override :
  project_id => project_id if project_id != null }    
  policy_type = "list"
  constraint  = "constraints/compute.vmExternalIpAccess"
  project_id  = each.value
  enforce     = false
}