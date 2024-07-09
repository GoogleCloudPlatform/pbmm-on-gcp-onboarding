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
  organization_id = local.parent_folder != "" ? null : local.org_id
  folder_id       = local.parent_folder != "" ? local.parent_folder : null
  policy_for      = local.parent_folder != "" ? "folder" : "organization"

  essential_contacts_domains_to_allow = concat(
    [for domain in var.essential_contacts_domains_to_allow : domain if can(regex("^@.*$", domain)) == true],
    [for domain in var.essential_contacts_domains_to_allow : "@${domain}" if can(regex("^@.*$", domain)) == false]
  )

  boolean_type_organization_policies = toset([
    "compute.disableNestedVirtualization",
    "compute.disableSerialPortAccess",
    "compute.skipDefaultNetworkCreation",
    "compute.restrictXpnProjectLienRemoval",
    "compute.disableVpcExternalIpv6",
    "compute.setNewProjectDefaultToZonalDNSOnly",
    "compute.requireOsLogin",
    "sql.restrictPublicIp",
    "sql.restrictAuthorizedNetworks",
    "iam.disableServiceAccountKeyCreation",
    "iam.automaticIamGrantsForDefaultServiceAccounts",
    "iam.disableServiceAccountKeyUpload",
    "storage.uniformBucketLevelAccess",
    "storage.publicAccessPrevention"
  ])

  private_pools = [local.cloud_build_private_worker_pool_id]
}

module "organization_policies_type_boolean" {
  source   = "terraform-google-modules/org-policy/google"
  version  = "~> 5.1"
  for_each = local.boolean_type_organization_policies

  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/${each.value}"
}


/******************************************
  Compute org policies
*******************************************/

module "org_vm_external_ip_access" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  folder_id       = local.folder_id
  policy_for      = "folder"
  policy_type     = "list"
  enforce         = "true"
  constraint      = "constraints/compute.vmExternalIpAccess"
}

module "org_policies_restrict_protocol_fowarding" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  count   = var.enforce_restrict_protocol_fowarding_constraint ? 1 : 0 # Conditional creation

  constraint        = "constraints/compute.restrictProtocolForwardingCreationForTypes"
  policy_for        = "folder"
  folder_id         = local.folder_id
  policy_type       = "list"
  # enforce           = "true"
  allow             = var.list_restrict_protocol_forwarding
  allow_list_length = length(var.list_restrict_protocol_forwarding)
  exclude_folders   = []
  exclude_projects  = []
}

/******************************************
  trusted Image Projects
*******************************************/
module "org_policies_require_trusted_images" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  count   = var.enforce_trusted_image_projects_constraint ? 1 : 0 # Conditional creation

  policy_for        = "folder" # Should be "organization" or "folder"
  folder_id         = local.folder_id
  policy_type       = "list"
  constraint        = "constraints/compute.trustedImageProjects"
  allow_list_length = length(var.list_trusted_image_projects)
  allow             = var.list_trusted_image_projects # List of trusted projects
}

# /******************************************
#   Restrict LoadBalancer Creation For Types
# *******************************************/
module "org_policies_restricted_loadbalancer_types" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  count   = var.enforce_allowed_lb_types_constraint ? 1 : 0 # Conditional creation

  folder_id         = local.folder_id  # Replace with your folder ID (if applicable)
  policy_for        = local.policy_for # Set to "organization" or "folder"
  policy_type       = "list"
  constraint        = "constraints/compute.restrictLoadBalancerCreationForTypes"
  exclude_folders   = []
  allow             = var.list_allowed_load_balancer
  allow_list_length = length(var.list_allowed_load_balancer)
}

# /******************************************
#   Disable Guest Attributes Access
# *******************************************/
module "org_policies_disable_guest_attribute_access" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  count   = var.enforce_disable_guest_attribute_access_constraint ? 1 : 0 # Conditional creation

  policy_for  = local.policy_for # Set to "organization" or "folder"
  folder_id   = local.folder_id  # Replace with your folder ID (if applicable)
  policy_type = "boolean"
  enforce     = true # Enable and enforce the constraint
  constraint  = "constraints/compute.disableGuestAttributesAccess"
}

# # /******************************************
# #   Restrict Vpc Peering
# # *******************************************/
# module "org_policies_restrict_vpc_peering" {
#   source      = "terraform-google-modules/org-policy/google"
#   version     = "~> 5.1"
#   enforce     = true
#   policy_for  = "folder"
#   folder_id   = local.folder_id
#   policy_type = "list"
#   constraint  = "constraints/compute.restrictVpcPeering"
# }

# /******************************************
#   IAM
# *******************************************/

resource "time_sleep" "wait_logs_export" {
  create_duration = "30s"
  depends_on = [
    module.logs_export
  ]
}

module "org_domain_restricted_sharing" {
  source  = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version = "~> 5.1"

  organization_id  = local.organization_id
  folder_id        = local.folder_id
  policy_for       = local.policy_for
  domains_to_allow = var.domains_to_allow

  depends_on = [
    time_sleep.wait_logs_export
  ]
}

# /******************************************
#   Allowed Policy Member Domains
# *******************************************/
module "org_policies_allowed_policy_member_domains" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"                                                     # Ensure compatibility with list_policy

  policy_for        = "folder"                                       # Should be "organization" or "folder"
  folder_id         = local.folder_id                                # If applying to a specific folder
  policy_type       = "list"                                         # List constraint type
  allow             = var.list_allowed_policy_member_domains         # The list of allowed domains
  allow_list_length = length(var.list_allowed_policy_member_domains)
  constraint        = "constraints/iam.allowedPolicyMemberDomains"
}

# /******************************************
#   Essential Contacts
# *******************************************/

module "domain_restricted_contacts" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  folder_id         = local.folder_id
  policy_for        = "folder"
  policy_type       = "list"
  allow_list_length = length(local.essential_contacts_domains_to_allow)
  allow             = local.essential_contacts_domains_to_allow
  constraint        = "constraints/essentialcontacts.allowedContactDomains"
}

/******************************************
  Cloud build
*******************************************/

module "allowed_worker_pools" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"
  count   = var.enforce_allowed_worker_pools && local.cloud_build_private_worker_pool_id != "" ? 1 : 0

  organization_id   = local.organization_id
  folder_id         = local.folder_id
  policy_for        = local.policy_for
  policy_type       = "list"
  allow_list_length = length(local.private_pools)
  allow             = local.private_pools
  constraint        = "constraints/cloudbuild.allowedWorkerPools"
}

# /******************************************
#   Access Context Manager Policy
# *******************************************/

resource "google_access_context_manager_access_policy" "access_policy" {
  count  = var.create_access_context_manager_access_policy ? 1 : 0
  parent = "organizations/${local.org_id}"
  title  = "default policy"
}

# /******************************************
#   Resource Location Restriction
# *******************************************/
# Module to Enable gcp.resourceLocations Org Policy
module "org_policies_resource_location_constraint" {
  source  = "terraform-google-modules/org-policy/google"
  version = ">= 3.77"                                        #"~> 3.0.2"
  count   = var.enforce_resource_location_constraint ? 1 : 0 # Conditional creation

  constraint        = "constraints/gcp.resourceLocations"
  folder_id         = local.folder_id
  policy_type       = "list"
  policy_for        = "folder"
  exclude_folders   = []
  allow             = var.allowed_gcp_resource_locations
  allow_list_length = length(var.allowed_gcp_resource_locations)
}