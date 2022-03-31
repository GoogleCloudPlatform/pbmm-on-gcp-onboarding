/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  organization_config = data.terraform_remote_state.bootstrap.outputs.organization_config
  net-host-prj = module.net-host-prj
  #Adding the net host project to the vpc controls list
  prod_vpc_svc_ctl = {
    for perim_type, svcperim in var.prod_vpc_svc_ctl : perim_type => {
      for prj, attrs in svcperim : prj => merge(
        {
          for attr, val in attrs : attr => val if attr != "resources"
        },
        {
          #resources = distinct(concat(attrs.resources, [module.net-host-prj.project_id]))
          #resources = distinct(concat(attrs.resources, [module.net-host-prj.project_id]))
        }
      )
    }
  }
}

# errors on the resource for loop
#Step #2 - "tf plan": │ Error: Invalid for_each argument
#Step #2 - "tf plan": │ 
#Step #2 - "tf plan": │   on ../../modules/vpc-service-controls/modules/regular_service_perimeter/main.tf line 22, in data "google_project" "resources":
#Step #2 - "tf plan": │   22:   for_each   = toset(var.resources)