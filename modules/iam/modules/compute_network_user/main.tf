/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "google_compute_subnetwork_iam_member" "member" {
  for_each   = toset(var.members)
  project    = var.project
  region     = var.region
  subnetwork = var.subnetwork
  member     = each.value
  role       = "roles/compute.networkUser"
}