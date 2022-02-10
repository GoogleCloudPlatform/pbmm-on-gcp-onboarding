/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  org_roles = [
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.projectCreator",
    "roles/iam.organizationRoleAdmin",
    "roles/storage.admin",
    "roles/accesscontextmanager.policyAdmin",
    "roles/compute.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/resourcemanager.projectDeleter",
    "roles/viewer",
  ]

  project_roles = [
    "roles/source.admin",
    "roles/secretmanager.secretAccessor",
  ]

  merged_org_roles = concat(var.sa_org_iam_permissions, local.org_roles)

  services = [
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "sourcerepo.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudkms.googleapis.com",
    "artifactregistry.googleapis.com", 
    "secretmanager.googleapis.com"
  ]

  merged_services = concat(var.services, local.services)

  module_labels = {
    date_modified = formatdate("YYYY-MM-DD",timestamp())
  }
  
  labels  = merge(var.labels, local.module_labels)

}
