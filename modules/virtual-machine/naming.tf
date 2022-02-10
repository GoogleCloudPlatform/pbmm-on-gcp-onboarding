/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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