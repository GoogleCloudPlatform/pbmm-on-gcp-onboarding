/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_vpc_svc_ctl = {
  regular_service_perimeter = {
    regular_service_perimeter_1 = {
      perimeter_name               = "regular_service_perimeter_prod_1"
      description                  = "Regular Service Perimeter 1"
      # match to nonp-network
      resources                    = []#"ospe-team-prod-hostproj"] #leave empty if using net host project. no empty strings.
      access_level                 = ["ospevsc_access_level_1_vsc"]
#      restricted_services          = [""]
#      resources_by_numbers         = [""]
#      access_level                 = ["access_level_name"]
#      restricted_services_dry_run  = [""]
#      resources_dry_run            = [""]
#      resources_dry_run_by_numbers = [""]
#      access_levels_dry_run        = [""]
#      vpc_accessible_services = {
#        enable_restriction = bool,
#        allowed_services   = [""],
#      }
#      dry_run  = bool
      live_run = true
    }
  }
  bridge_service_perimeter = { #Remove inner object if not used
 #   bridge_service_perimeter_1 = {
 #     description          = ""
 #     perimeter_name       = ""
 #     resources            = [""]
 #     resources_by_numbers = [""]
 #   }
  }
}