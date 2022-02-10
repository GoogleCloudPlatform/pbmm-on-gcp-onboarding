/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "fgt_ha_password" {
  value = random_password.fgt_ha_password.result
}

output "port_to_network_map" {
  value = { for port, value in var.network_ports : port => value.subnetwork }
}

output "internal_route" {
  value = google_compute_route.internal.name
}