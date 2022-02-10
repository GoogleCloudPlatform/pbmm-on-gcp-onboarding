/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "policy_name" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  department_code     = var.department_code
  environment         = var.environment
  location            = var.location
  user_defined_string = var.user_defined_string
}

module "access_list_names" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  for_each        = var.access_level
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.value.name
}

module "regular_service_perimeter_names" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  for_each        = var.regular_service_perimeter
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.value.perimeter_name
}

module "bridge_service_perimeter_names" {
  source = "../naming-standard//modules/gcp/vpc_svc_ctl"

  for_each        = var.bridge_service_perimeter
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.value.perimeter_name
}