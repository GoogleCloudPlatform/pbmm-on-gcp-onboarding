/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


output "name" {
  value = google_compute_instance.virtual_machine.name
}

output "instance_id" {
  value = google_compute_instance.virtual_machine.id
}

output "self_link" {
  value = google_compute_instance.virtual_machine.self_link
}

output "hostname" {
  value = google_compute_instance.virtual_machine.hostname
}

output "zone" {
  value = google_compute_instance.virtual_machine.zone
}

output "tags" {
  value = google_compute_instance.virtual_machine.tags
}

output "can_ip_forward" {
  value = google_compute_instance.virtual_machine.can_ip_forward
}

output "ip_addresses" {
  description = "IP Addresses"
  value = { for id, interface in google_compute_instance.virtual_machine.network_interface :
    id => interface
  }
}

output "domain" {
  value       = var.domain
  description = "Output of domain for test cases"
}