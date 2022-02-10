/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

resource "random_id" "random_id" {
  byte_length = 2
}

module "custom_roles" {
  source              = "../"
  org_id              = var.org_id
  user_defined_string = var.user_defined_string
  location            = var.location
  department_code     = var.department_code
  environment         = var.environment
  custom_roles = {
    bq_admin = {
      title       = "Custom BQ Admin - ${random_id.random_id.hex}"
      description = "BQ admin without data reading capabilities"
      role_id     = "custom_bq_admin_${random_id.random_id.hex}"
      permissions = [
        "bigquery.bireservations.get",
        "bigquery.bireservations.update",
        "bigquery.capacityCommitments.create",
        "bigquery.capacityCommitments.delete",
        "bigquery.capacityCommitments.get",
        "bigquery.capacityCommitments.list",
        "bigquery.capacityCommitments.update",
        "bigquery.config.get",
        "bigquery.config.update",
        "bigquery.connections.create",
        "bigquery.connections.delete",
        "bigquery.connections.get",
        "bigquery.connections.getIamPolicy",
        "bigquery.connections.list",
        "bigquery.connections.setIamPolicy",
        "bigquery.connections.update",
        "bigquery.connections.use",
        "bigquery.datasets.create",
        "bigquery.datasets.delete",
        "bigquery.datasets.get",
        "bigquery.datasets.getIamPolicy",
        "bigquery.datasets.setIamPolicy",
        "bigquery.datasets.update",
        "bigquery.datasets.updateTag",
        "bigquery.jobs.create",
        "bigquery.jobs.get",
        "bigquery.jobs.list",
        "bigquery.jobs.listAll",
        "bigquery.jobs.update",
        "bigquery.models.create",
        "bigquery.models.delete",
        "bigquery.models.export",
        "bigquery.models.getMetadata",
        "bigquery.models.list",
        "bigquery.models.updateMetadata",
        "bigquery.models.updateTag",
        "bigquery.readsessions.create",
        "bigquery.readsessions.update",
        "bigquery.reservationAssignments.create",
        "bigquery.reservationAssignments.delete",
        "bigquery.reservationAssignments.list",
        "bigquery.reservationAssignments.search",
        "bigquery.reservations.create",
        "bigquery.reservations.delete",
        "bigquery.reservations.get",
        "bigquery.reservations.list",
        "bigquery.reservations.update",
        "bigquery.routines.create",
        "bigquery.routines.delete",
        "bigquery.routines.get",
        "bigquery.routines.list",
        "bigquery.routines.update",
        "bigquery.savedqueries.create",
        "bigquery.savedqueries.delete",
        "bigquery.savedqueries.get",
        "bigquery.savedqueries.list",
        "bigquery.savedqueries.update",
        "bigquery.tables.create",
        "bigquery.tables.delete",
        "bigquery.tables.export",
        "bigquery.tables.get",
        "bigquery.tables.getIamPolicy",
        "bigquery.tables.list",
        "bigquery.tables.setCategory",
        "bigquery.tables.setIamPolicy",
        "bigquery.tables.update",
        "bigquery.tables.updateTag",
        "bigquery.transfers.get",
        "bigquery.transfers.update",
        "resourcemanager.projects.get",
        "resourcemanager.projects.list",
      ]
    }
    bq_viewer = {
      title       = "Custom BQ Viewer - ${random_id.random_id.hex}"
      description = "BQ Viewer without data reading capabilities"
      role_id     = "custom_bq_viewer_${random_id.random_id.hex}"
      permissions = [
        "bigquery.bireservations.get",
        "bigquery.capacityCommitments.get",
        "bigquery.capacityCommitments.list",
        "bigquery.config.get",
        "bigquery.connections.get",
        "bigquery.connections.list",
        "bigquery.datasets.get",
        "bigquery.jobs.get",
        "bigquery.jobs.list",
        "bigquery.jobs.listAll",
        "bigquery.models.getMetadata",
        "bigquery.models.list",
        "bigquery.reservationAssignments.list",
        "bigquery.reservations.get",
        "bigquery.reservations.list",
        "bigquery.routines.get",
        "bigquery.routines.list",
        "bigquery.savedqueries.get",
        "bigquery.savedqueries.list",
        "bigquery.tables.get",
        "bigquery.tables.list",
        "bigquery.transfers.get",
        "resourcemanager.projects.get",
        "resourcemanager.projects.list",
      ]
    }
  }
}