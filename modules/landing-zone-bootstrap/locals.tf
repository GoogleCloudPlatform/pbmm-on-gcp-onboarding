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
  org_roles = [
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/logging.admin",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.projectCreator",
    "roles/iam.organizationRoleAdmin",
    "roles/storage.admin",
    "roles/cloudkms.admin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
    "roles/accesscontextmanager.policyAdmin",
    "roles/compute.admin",
    "roles/monitoring.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/resourcemanager.projectDeleter",
    "roles/resourcemanager.projectMover",
    "roles/viewer",
    "roles/iam.serviceAccountTokenCreator",
    "roles/source.admin",
    "roles/cloudbuild.workerPoolOwner",
  ]

  project_roles = [
    "roles/source.admin",
    "roles/secretmanager.secretAccessor",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",  
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
  ]

  merged_services = concat(var.services, local.services)

  module_labels = {
    date_modified = formatdate("YYYY-MM-DD",timestamp())
  }
  
  labels  = merge(var.labels, local.module_labels)

}
