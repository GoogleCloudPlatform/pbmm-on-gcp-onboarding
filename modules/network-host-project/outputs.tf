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

output "network_name" {
  description = "The name of the VPC being created"
  value = { for name, value in module.network :
    name => value.network_name
  }
}

output "subnetwork_name" {
  description = "The self link of the VPC subnets being created"
  value = { for name, value in module.network :
    name => value.subnet_name
  }
}

output "project_id" {
    description = "The ID of the host project"
    value       = module.project.project_id
}

output "service_accounts" {
  description = "Product robot service accounts in project."
  value =   module.project.service_accounts
}
