/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  sa_create_assign = defaults(var.sa_create_assign, {
    project = var.project
  })
  project_iam = defaults(var.project_iam, {
    project = var.project
  })
  compute_network_users = defaults(var.compute_network_users, {
    project = var.project
  })
  organization_iam = defaults(var.organization_iam, {
    organization = var.organization
  })
}
