/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

module "allow_admins_name" {
  source = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${var.network}-ingress-admins"
}

module "allow_internal_name" {
  source = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${var.network}-ingress-internal"
}

module "allow_zone_internal_ingress_name" {
  for_each = toset(var.zone_list)
  source   = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "allow-${each.value}-internal-ingress"
}

module "deny_all_egress_name" {
  source = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${var.network}-deny-all-egress"
}

module "bastion_rule_name" {
  source = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${var.network}-iap-bastian-ports"
}

module "iap_rules_names" {
  for_each = var.custom_iap_rules
  source   = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "${var.network}-iap-${each.value.rule_name}"
}

module "custom_rules_names" {
  for_each = var.custom_rules
  source   = "../naming-standard//modules/gcp/firewall_rule"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = each.key
}