/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

nonprod_vpc_svc_ctl = { 
  regular_service_perimeter = {
    regular_service_perimeter_1 = {
      perimeter_name               = "regular_service_perimeter_nonp_1"
      description                  = "Regular Service Perimeter nonp 1"
 #     restricted_services          = [""]
      resources                    = []#"ospe-team-nonp-hostproject"] #leave empty if using net host project. no empty strings.
 #     resources_by_numbers         = ["ospe-team-nonp-hostproject"]
      access_level                 = ["ospevsc_access_level_1_vsc"]
 #     restricted_services_dry_run  = [""]
 #     resources_dry_run            = [""]
 #     resources_dry_run_by_numbers = [""]
 #     access_levels_dry_run        = [""]
 #     vpc_accessible_services = {
 #       enable_restriction = true,
 #       allowed_services   = [ "logging.googleapis.com"],
 #     }
 #     dry_run  = true
      live_run = true #false # bool
    }
  }
  bridge_service_perimeter = { #Remove inner object if not used
    /*bridge_service_perimeter_1 = {
      description          = ""
      perimeter_name       = ""
      resources            = [""]
      resources_by_numbers = [""]
    }*/ 
  }
}