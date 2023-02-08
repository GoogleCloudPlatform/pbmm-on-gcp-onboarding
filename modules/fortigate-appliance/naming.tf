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
  for_each = local.instances
  source   = "../naming-standard//modules/gcp/virtual_machine"

  department_code     = var.department_code
  environment         = var.environment
  location            = var.location
  user_defined_string = var.user_defined_string
  device_type         = "FWL"
  number_suffix       = each.value.number_suffix
}

module "fortigate_service_account" {
  source = "../naming-standard//modules/gcp/service_account"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "fortiappliance"
}

module "virtual_machine_instance_group" {
  for_each = local.instances
  source   = "../naming-standard//modules/gcp/virtual_machine_instance_group"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location
  device_type     = "CNR"

  user_defined_string = "instance-group-${each.value.zone}"
}

module "compute_address_internal_active_ip" {
  for_each = var.network_ports
  source   = "../naming-standard//modules/gcp/compute_address_internal_ip"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${each.value.port_name}-active"
}

module "compute_address_public_active_ip" {
  source   = "../naming-standard//modules/gcp/compute_address_external_ip"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "port1-public-active"
}

module "compute_address_internal_passive_ip" {
  for_each = var.network_ports
  source   = "../naming-standard//modules/gcp/compute_address_internal_ip"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${each.value.port_name}-passive"
}

module "compute_address_public_passive_ip" {
  source   = "../naming-standard//modules/gcp/compute_address_external_ip"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "port1-public-passive"
}

