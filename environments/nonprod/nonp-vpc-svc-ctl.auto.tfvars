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
      resources                    = ["dcde-team-nonp-hostproject"] #leave empty if using net host project. no empty strings.
      access_level                 = ["dcdevsc_access_level_1_vsc"]
      live_run = true # REQUIRED EDIT
    }
  }
  bridge_service_perimeter = {
  }
}