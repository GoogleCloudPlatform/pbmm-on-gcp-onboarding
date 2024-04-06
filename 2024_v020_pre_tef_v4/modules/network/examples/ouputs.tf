/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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