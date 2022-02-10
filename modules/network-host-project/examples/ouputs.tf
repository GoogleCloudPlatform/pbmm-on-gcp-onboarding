/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "project_id" {
  value       = module.host_project.project_id
  description = "ID of host project"
}

# network
output "network" {
  value       = module.host_project.network
  description = "The VPC resource being created"
}

## subnets
output "subnets" {
  value       = module.host_project.subnets
  description = "The created subnet resources"
}

## routes 
output "routes" {
  value       = module.host_project.routes
  description = "The created routes resources"
}

## cloud nat
output "cloud_nat" {
  description = "Cloud NAT"
  value       = module.host_project.cloud_nat
}

output "nat_ip_allocate_option" {
  description = "NAT IP allocation mode"
  value       = module.host_project.nat_ip_allocate_option
}

output "nat_router" {
  description = "Cloud NAT router"
  value       = module.host_project.nat_router
}