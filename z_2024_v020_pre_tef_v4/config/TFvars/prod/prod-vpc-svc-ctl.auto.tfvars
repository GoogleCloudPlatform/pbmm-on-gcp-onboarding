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



prod_vpc_svc_ctl = {
  regular_service_perimeter = {
    regular_service_perimeter_1 = {
      perimeter_name               = "regular_service_perimeter_1"
      description                  = "Regular Service Perimeter 1"
      restricted_services          = [""]
      resources                    = ["project-name"] #No empty strings. Leave as empty array if not used
      resources_by_numbers         = [""]
      access_level                 = ["access_level_name"]
      restricted_services_dry_run  = [""]
      resources_dry_run            = [""]
      resources_dry_run_by_numbers = [""]
      access_levels_dry_run        = [""]
      vpc_accessible_services = {
        enable_restriction = bool,
        allowed_services   = [""],
      }
      dry_run  = bool
      live_run = bool
    }
  }
  bridge_service_perimeter = { #Remove inner object if not used
    bridge_service_perimeter_1 = {
      description          = ""
      perimeter_name       = ""
      resources            = [""]
      resources_by_numbers = [""]
    }
  }
}