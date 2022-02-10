/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "type" {
  description = "The DNS zone type."
  value       = var.type
}

output "name" {
  description = "The DNS zone name."

  value = element(
    concat(
      google_dns_managed_zone.peering.*.name,
      google_dns_managed_zone.forwarding.*.name,
      google_dns_managed_zone.private.*.name,
      google_dns_managed_zone.public.*.name,
    ),
    0,
  )
}

output "domain" {
  description = "The DNS zone domain."

  value = element(
    concat(
      google_dns_managed_zone.peering.*.dns_name,
      google_dns_managed_zone.forwarding.*.dns_name,
      google_dns_managed_zone.private.*.dns_name,
      google_dns_managed_zone.public.*.dns_name,
    ),
    0,
  )
}

output "name_servers" {
  description = "The DNS zone name servers."

  value = flatten(
    concat(
      google_dns_managed_zone.peering.*.name_servers,
      google_dns_managed_zone.forwarding.*.name_servers,
      google_dns_managed_zone.private.*.name_servers,
      google_dns_managed_zone.public.*.name_servers,
    ),
  )
}