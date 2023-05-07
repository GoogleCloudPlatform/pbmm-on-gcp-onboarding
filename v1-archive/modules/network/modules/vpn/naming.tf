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



module "ha_vpn_name" {
  source = "../../../naming-standard//modules/gcp/ha_vpn_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = var.ha_vpn_name
}

module "ext_vpn_name" {
  source = "../../../naming-standard//modules/gcp/external_vpn_name"

  department_code     = var.department_code
  environment         = var.environment
  location            = var.location
  user_defined_string = var.ext_vpn_name
}

module "vpn_tunnel_name" {
  for_each        = { for peer in var.peer_external_gateway.interfaces : peer.id => peer }
  source          = "../../../naming-standard//modules/gcp/vpn_tunnel_name"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location
  number_suffix   = each.value.id
  user_defined_string = var.vpn_tunnel_name
}
