/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "gc_governance_prefix" {
  value = local.gc_prefix
}

output "csp_region_code" {
  value = local.csp_region[var.location]
}