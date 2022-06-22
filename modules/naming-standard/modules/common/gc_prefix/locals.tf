/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  csp_region = {
    northamerica-northeast1 = "e"
  }

  gc_prefix = "${var.department_code}${var.environment}${local.csp_region[var.location]}"
}
