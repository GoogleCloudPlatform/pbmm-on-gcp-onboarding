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



module "vm_name" {
  source = "../naming-standard//modules/gcp/virtual_machine"

  department_code     = var.department_code
  environment         = var.environment
  location            = var.location
  user_defined_string = var.user_defined_string
  device_type         = var.device_type
  number_suffix       = var.number_suffix
}

module "boot_disk_name" {
  source = "../naming-standard//modules/gcp/managed_disk_os"

  parent_resource = module.vm_name.result
}

module "data_disk_name" {
  for_each = { for disk in var.disks : disk.id => disk }
  source   = "../naming-standard//modules/gcp/managed_disk_data"

  parent_resource = module.vm_name.result
  number_suffix   = each.value.id
}