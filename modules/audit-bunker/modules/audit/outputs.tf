/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "sink_name" {
  description = "Log Sink"
  value       = google_logging_organization_sink.audit_sink.name
}

output "bucket_name" {
  description = "Sink bucket name"
  value       = google_storage_bucket.audit_bucket.name
}