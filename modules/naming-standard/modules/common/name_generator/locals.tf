/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  type        = var.type != "generic" ? var.type : lookup(var.name_sections, "type", "")
  device_type = local.set_case_lower ? lower(var.device_type) : var.device_type

  # generated name
  rendered = templatefile("${path.module}/../../../configs/${var.type_parent}/${var.type}.tpl",
    {
      # common
      gc_governance_prefix = var.gc_prefix

      # type
      type = local.type

      # groups: mg, subscription, rg
      owner                          = lookup(var.name_sections, "owner", "")
      user_defined_string            = lookup(var.name_sections, "user_defined_string", "")
      subscription_owner             = lookup(var.name_sections, "subscription_owner", "")
      additional_user_defined_string = lookup(var.name_sections, "additional_user_defined_string", "")

      # resources
      device_type   = local.device_type
      number_suffix = lookup(var.name_sections, "number_suffix", "")

      # parent resource's in naming
      parent_resource = lookup(var.name_sections, "parent_resource", "")

      # policy
      scope        = lookup(var.name_sections, "scope", "")
      service_name = lookup(var.name_sections, "service_name", "")
      policy_type  = lookup(var.name_sections, "policy_type", "")
    }
  )

  set_case_lower = lookup(var.name_sections, "set_case", "") == "lower" ? true : false

  name   = local.set_case_lower ? lower(local.rendered) : local.rendered
  prefix = local.set_case_lower ? lower(var.gc_prefix) : var.gc_prefix

  name_without_type_replacement = var.type == "vm" ? lookup(var.name_sections, "number_suffix") : "-${local.type}\\d*"
}
