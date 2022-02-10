/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "audit_streams_bucket_name" {
  source = "../../../naming-standard//modules/gcp/storage"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = var.bucket_name
}

module "log_sink_name" {
  source = "../../../naming-standard//modules/gcp/log_sink"

  department_code = var.department_code
  environment     = var.environment
  location        = var.region

  user_defined_string = var.sink_name
}