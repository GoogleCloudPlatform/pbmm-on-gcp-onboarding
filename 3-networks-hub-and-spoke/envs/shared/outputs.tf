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

output "dns_hub_project_id" {
  value       = local.dns_hub_project_id
  description = "The DNS hub project ID"
}

output "base_shared_vpc_project_id" {
  value       = regex("prj-net-hub-base-\\w+", module.base_shared_vpc.subnets_self_links[0])
  description = "The project id of the primary network base hub VPC"
}

output "base_shared_vpc_network_name" {
  value       = module.base_shared_vpc.network_name
  description = "The name of the primary network base hub VPC"
}

output "base_shared_vpc_network_self_link" {
  value       = module.base_shared_vpc.network_self_link
  description = "The self link of the primary network base hub VPC"
}

output "base_shared_vpc_subnets_names" {
  value       = module.base_shared_vpc.subnets_names
  description = "The names of the primary network base hub VPC subnets"
}

output "base_shared_vpc_subnets_ips" {
  value       = module.base_shared_vpc.subnets_ips
  description = "The ips of the primary network base hub VPC subnets"
}

output "base_shared_vpc_subnets_self_links" {
  value       = module.base_shared_vpc.subnets_self_links
  description = "The self links of the primary network base hub VPC subnets"
}

output "base_shared_vpc_subnets_regions" {
  value       = module.base_shared_vpc.subnets_regions
  description = "The regions of the primary network base hub VPC subnets"
}
