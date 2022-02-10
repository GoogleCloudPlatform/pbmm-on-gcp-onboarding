/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "sink_buckets" {
  description = "Sink buckets"
  value = { for name, bucket in module.audit :
    name => bucket.bucket_name
  }
}

output "log_sinks" {
  description = "Org log sinks"
  value = { for name, sink in module.audit :
    name => sink.sink_name
  }
}

output "project_id" {
  description = "Audit project ID"
  value       = module.audit_project.project_id
}