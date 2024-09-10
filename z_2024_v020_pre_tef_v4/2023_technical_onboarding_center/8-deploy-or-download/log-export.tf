# random suffix to prevent collisions
resource "random_id" "suffix" {
  byte_length = 4
}

module "cs-logsink-logbucketsink" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.8.0"

  destination_uri      = module.cs-logging-destination.destination_uri
  log_sink_name        = "${var.org_id}-logbucketsink-${random_id.suffix.hex}"
  parent_resource_id   = var.org_id
  parent_resource_type = "organization"
  include_children     = true
}


module "cs-logging-destination" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 7.8.0"

  project_id               = module.cs-logging-hh015-gz357.project_id
  name                     = "logdest-${random_id.suffix.hex}"
  location                 = "global"
  retention_days           = 365
  log_sink_writer_identity = module.cs-logsink-logbucketsink.writer_identity
}
