/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "fgt_ha_password" {
  value = module.fortigates.fgt_ha_password
}
output "Terraform_RW_User_API_key" {
  value = module.fortigates.Terraform_RW_User_API_key
}
output "port_to_network_map" {
  value = module.fortigates.port_to_network_map
}

output "mirror_lb_address" {
  value = module.fortigates.mirror_lb_address
}
output "internal_route" {
  value = module.fortigates.internal_route
}
output "project_name" {
  value = module.project.project_id
}