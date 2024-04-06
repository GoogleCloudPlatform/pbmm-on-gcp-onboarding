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