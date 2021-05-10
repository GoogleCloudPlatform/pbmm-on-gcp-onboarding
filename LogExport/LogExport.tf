resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = module.destination.destination_uri
#  filter                 = "resource.type = gce_instance"
  log_sink_name          = "bigquery_org_${random_string.suffix.result}"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "organization"
  unique_writer_identity = false
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/bigquery"
  project_id               = var.project_id
  dataset_name             = "bq_org_${random_string.suffix.result}"
  log_sink_writer_identity = module.log_export.writer_identity
}
