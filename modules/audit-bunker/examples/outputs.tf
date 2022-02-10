/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "sink_buckets" {
  value = module.audit.sink_buckets
}

output "log_sinks" {
  value = module.audit.log_sinks
}

output "project_id" {
  value = module.audit.project_id
}

output "random_id" {
  value = random_id.random_id.hex
}