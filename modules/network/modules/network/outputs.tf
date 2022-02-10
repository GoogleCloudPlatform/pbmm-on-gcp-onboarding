/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}