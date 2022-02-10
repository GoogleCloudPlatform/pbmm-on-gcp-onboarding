/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


output "name" {
  value = module.virtual_machine.name
}

output "hostname" {
  value = module.virtual_machine.hostname
}

output "zone" {
  value = module.virtual_machine.zone
}

output "tags" {
  value = module.virtual_machine.tags
}

output "can_ip_forward" {
  value = module.virtual_machine.can_ip_forward
}

output "ip_addresses" {
  value = module.virtual_machine.ip_addresses
}

output "project_id" {
  value = module.project.project_id
}

output "domain" {
  value = module.virtual_machine.domain
}