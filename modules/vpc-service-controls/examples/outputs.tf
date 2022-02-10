/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "policy_id" {
  value = module.svc_ctl.policy_id
}

output "regular_service_perimeter_names" {
  value = module.svc_ctl.regular_service_perimeter_names
}

output "bridge_service_perimeter_names" {
  value = module.svc_ctl.bridge_service_perimeter_names
}