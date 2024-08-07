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
locals {
  env                = "identity"
  spoke_config       = try(one(module.vpc_config).spoke_config, null)
  environment_code   = try(local.spoke_config.vpc_config.env_code, "i")
  identity_enabled   = try(module.env_enabled.identity_enabled, false)
  restricted_enabled = try(module.env_enabled.restricted_enabled, false)
}

module "env_enabled" {
  source              = "../../modules/env_enabled"
  remote_state_bucket = var.remote_state_bucket
}

module "vpc_config" {
  source = "../../modules/nhas_config/vpc_config"
  count  = local.identity_enabled ? 1 : 0

  env                = local.env
  config_file        = abspath("${path.module}/../../../config/vpc_config.yaml")
  restricted_enabled = local.restricted_enabled
}

module "base_env" {
  source = "../../modules/base_env"
  count  = local.identity_enabled ? 1 : 0

  env                              = local.env
  environment_code                 = local.environment_code
  access_context_manager_policy_id = var.access_context_manager_policy_id
  perimeter_additional_members     = var.perimeter_additional_members
  domain                           = var.domain
  ingress_policies                 = var.ingress_policies
  egress_policies                  = var.egress_policies
  enable_partner_interconnect      = false
  remote_state_bucket              = var.remote_state_bucket
  tfc_org_name                     = var.tfc_org_name
  spoke_config                     = local.spoke_config
}
