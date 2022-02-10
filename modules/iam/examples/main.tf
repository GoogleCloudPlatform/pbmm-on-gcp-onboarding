/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "random_string" "random_string" {
  length  = 4
  upper   = false
  special = false
  number  = false
}

module "project" {
  source                         = "../../project"
  billing_account                = var.billing_account
  department_code                = var.department_code
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = random_string.random_string.result
  owner                          = var.owner
  environment                    = var.environment
  location                       = var.location
  parent                         = var.parent
  services                       = []
}

resource "google_compute_network" "network" {
  project                 = module.project.project_id
  name                    = "transit-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  project       = module.project.project_id
  name          = "subnetwork"
  ip_cidr_range = "10.1.0.0/16"
  region        = "northamerica-northeast1"
  network       = google_compute_network.network.id
}

resource "google_folder" "folder" {
  display_name = "unittest-${random_string.random_string.result}"
  parent       = var.parent
}

module "iam" {
  source = "../"

  project = module.project.project_id
  sa_create_assign = [
    {
      account_id   = "test-account"
      display_name = "test1 display"
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    },
    {
      account_id   = "another-test"
      display_name = "Another Test"
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    }
  ]
  project_iam = [
    {
      member  = "group:name@name.canada.ca"
      project = module.project.project_id
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    },
    {
      member = "group:name@name.canada.ca"
      roles = [
        "roles/viewer",
      ]
    }
  ]
  compute_network_users = [
    {
      members = [
        "group:name@name.canada.ca",
      ]
      subnetwork = google_compute_subnetwork.subnetwork.name
      region     = google_compute_subnetwork.subnetwork.region
    }
  ]
  folder_iam = [
    {
      member = "group:name@name.canada.ca"
      folder = google_folder.folder.name
      roles = [
        "roles/viewer",
      ]
    },
  ]
}

module "organization_iam" {
  source = "../"
  organization_iam = [
    {
      member       = "group:name@name.canada.ca"
      organization = var.organization
      roles = [
        "roles/viewer",
      ]
    },
  ]
  depends_on = [
    module.iam
  ]
}