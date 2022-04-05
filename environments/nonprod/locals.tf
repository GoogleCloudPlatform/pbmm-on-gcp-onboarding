/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  organization_config = data.terraform_remote_state.bootstrap.outputs.organization_config
  net-host-prj = module.net-host-prj

  /*#adding the nonprod net host project to the vpc controls list variable
  nonprod_vpc_svc_ctl = {
   for perim_type, svcperim in var.nonprod_vpc_svc_ctl : perim_type => {
      for prj, attrs in svcperim : prj => merge(
        {
          for attr, val in attrs : attr => val if attr != "resources"
        },
        {
          # if this block from line 10 is uncommented - comment below for resources until the following issue is resolved
          # https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/40
          resources = distinct(concat(attrs.resources, [module.net-host-prj.project_id]))
        }
      )
    }
  }*/
}