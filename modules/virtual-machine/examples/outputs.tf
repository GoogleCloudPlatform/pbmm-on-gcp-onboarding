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