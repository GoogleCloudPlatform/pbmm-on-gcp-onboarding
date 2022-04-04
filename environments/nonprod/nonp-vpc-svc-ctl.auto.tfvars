/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

nonprod_vpc_svc_ctl = { 
  regular_service_perimeter = {
    regular_service_perimeter_1 = { #No empty strings. Leave as empty array if not used.
      perimeter_name               = "regular_service_perimeter_nonp_1"
      description                  = "Regular Service Perimeter Nonp 1"
      restricted_services          = []
      resources                    = [] #"project-name"
      resources_by_numbers         = []
      access_level                 = [] #"access_level_nonp_1"
      restricted_services_dry_run  = []
      resources_dry_run            = []
      resources_dry_run_by_numbers = []
      access_levels_dry_run        = []
      vpc_accessible_services = {
        enable_restriction = true, #Optional Edit
        allowed_services   = [],
      }
      dry_run  = false #Optional Edit
      live_run = true #Optional Edit
    }
  }
  bridge_service_perimeter = { #Remove inner object if not used
#    bridge_service_perimeter_1 = {
#      description          = ""
#      perimeter_name       = ""
#      resources            = [""]
#      resources_by_numbers = [""]
    }
  }
}