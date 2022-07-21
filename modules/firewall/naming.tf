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