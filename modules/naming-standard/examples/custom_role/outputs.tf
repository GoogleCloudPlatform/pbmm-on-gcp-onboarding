/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "result" {
  value = module.example_custom_role.result
}

output "result_without_type" {
  value = module.example_custom_role.result_without_type
}
