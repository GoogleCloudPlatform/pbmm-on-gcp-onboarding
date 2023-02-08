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
  platform_roles = merge(
    local.application_roles,
    local.network_administrator_roles,
    local.security_operator_roles,
    local.platform_operator_roles,
    local.domain_administrator_role,
    local.read_only_roles,
    local.billing_administrator_role,
    local.billing_operations_role,
    local.billing_viewonly_role,
    var.custom_roles,
  )
}