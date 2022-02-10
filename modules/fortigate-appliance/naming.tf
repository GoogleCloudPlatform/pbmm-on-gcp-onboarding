/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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

