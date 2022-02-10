/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

nonprod_vpc_svc_ctl = { 
  regular_service_perimeter = {
    regular_service_perimeter_1 = {
      perimeter_name               = "regular_service_perimeter_1"
      description                  = "Regular Service Perimeter 1"
      restricted_services          = [""]
      resources                    = ["project-name"] #No empty strings. Leave as empty array if not used.
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