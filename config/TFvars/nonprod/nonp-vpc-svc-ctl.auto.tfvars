/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

nonprod_vpc_svc_ctl = {
  regular_service_perimeter = {
    regular_service_perimeter_1 = {
      perimeter_name               = "nonprod_regular_perimeter_bootstrap<RAND>"
      description                  = "Regular Service Perimeter for nonprod bootstrap project"
      restricted_services          = [
        "logging.googleapis.com"
      ]
      resources                    = ["projects/abse-go-landingzone<RAND>-yp"] #leave empty if using net host project. no empty strings.
      resources_by_numbers         = []
      access_level                 = ["absevsc_usca_access_vsc"]
      restricted_services_dry_run  = [
        "logging.googleapis.com"
      ]
      resources_dry_run            = ["projects/abse-go-landingzone<RAND>-yp"]
      resources_dry_run_by_numbers = []
      access_levels_dry_run        = ["absevsc_usca_access_vsc"]
      vpc_accessible_services = {
        enable_restriction = true
        allowed_services   = [
          "logging.googleapis.com"
        ]
      }
      dry_run  = true
      live_run = false
    }
    regular_service_perimeter_2 = {
      perimeter_name               = "nonprod_regular_perimeter_npnethost<RAND>"
      description                  = "Regular Service Perimeter for nonprod net host project"
      restricted_services          = [
        "monitoring.googleapis.com"
      ]
      resources                    = ["projects/abse-go-nonprodnethost<RAND>-yp"] #leave empty if using net host project. no empty strings.
      resources_by_numbers         = []
      access_level                 = ["absevsc_usca_access_vsc"]
      restricted_services_dry_run  = [
        "monitoring.googleapis.com"
      ]
      resources_dry_run            = ["projects/abse-go-nonprodnethost<RAND>-yp"]
      resources_dry_run_by_numbers = []
      access_levels_dry_run        = ["absevsc_usca_access_vsc"]
      vpc_accessible_services = {
        enable_restriction = true
        allowed_services   = [
          "monitoring.googleapis.com"
        ]
      }
      dry_run  = true
      live_run = false
    }
  }
  bridge_service_perimeter = {
    bridge_service_perimeter_1 = {
      description                  = "Bridge Service Perimeter for nonprod bootstrap and nethost project"
      perimeter_name               = "nonprod_bridge_perimeter_bpnp<RAND>"
      resources                    = ["projects/abse-go-landingzone<RAND>-yp", "projects/abse-go-nonprodnethost<RAND>-yp"]
      resources_by_numbers         = []
      resources_dry_run            = ["projects/abse-go-landingzone<RAND>-yp", "projects/abse-go-nonprodnethost<RAND>-yp"]
      resources_dry_run_by_numbers = []
      dry_run  = true
      live_run = false
    }
  }
}