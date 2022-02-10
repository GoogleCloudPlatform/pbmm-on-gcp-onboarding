/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "policy_id" {
  value = local.policy_id
}

output "parent_id" {
  value = var.parent_id
}

output "regular_service_perimeter_names" {
  value = { for name, perimeter in module.regular_service_perimeter :
    name => perimeter.name
  }
}

output "bridge_service_perimeter_names" {
  value = { for name, perimeter in module.bridge_service_perimeter :
    name => perimeter.name
  }
}
