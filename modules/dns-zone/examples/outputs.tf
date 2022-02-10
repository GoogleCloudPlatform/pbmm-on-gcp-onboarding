/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "public_zone_name_servers" {
  description = "Public Zone name servers."
  value       = module.public_zone.name_servers
}

output "private_zone_name_servers" {
  description = "Private Zone name servers."
  value       = module.private_zone.name_servers
}

output "forwarding_zone_name_servers" {
  description = "Forwarding Zone name servers."
  value       = module.forwarding_zone.name_servers
}