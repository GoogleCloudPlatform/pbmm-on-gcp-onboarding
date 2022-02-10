/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  service_account_cloud_services = "${google_project.project.number}@cloudservices.gserviceaccount.com"
  service_accounts_default = {
    bq      = "bq-${google_project.project.number}@bigquery-encryption.iam.gserviceaccount.com"
    compute = "${google_project.project.number}-compute@developer.gserviceaccount.com"
    gae     = "${google_project.project.project_id}@appspot.gserviceaccount.com"
  }
  service_accounts_robot_services = {
    cloudasset        = "gcp-sa-cloudasset"
    cloudbuild        = "gcp-sa-cloudbuild"
    compute           = "compute-system"
    container-engine  = "container-engine-robot"
    containerregistry = "containerregistry"
    dataflow          = "dataflow-service-producer-prod"
    dataproc          = "dataproc-accounts"
    gae-flex          = "gae-api-prod"
    gcf               = "gcf-admin-robot"
    pubsub            = "gcp-sa-pubsub"
    storage           = "gs-project-accounts"
  }
  service_accounts_robots = {
    for service, name in local.service_accounts_robot_services :
    service => "service-${google_project.project.number}@${name}.iam.gserviceaccount.com"
  }
}
