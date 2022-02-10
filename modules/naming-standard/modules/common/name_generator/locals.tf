/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/


locals {
  # configs
  resource_naming = yamldecode(file("${path.module}/../../../configs/resource_naming_patterns.yaml"))

  set_case_lower = lookup(var.name_sections, "set_case", "") == "lower" ? true : false

  # child types for resources which have a consistent parent naming scheme
  child_types           = var.type_parent != "" ? local.resource_naming.type[var.type_parent] : null
  is_child_type_present = local.child_types != null ? true : false

  # list of common child naming prefixes
  prefix_templates = local.is_child_type_present ? local.child_types.common_prefixes : []

  # gather prefix index and suffix, if found
  prefix_index    = local.is_child_type_present ? local.child_types[var.type].commmon_prefix_index : null
  suffix_template = local.is_child_type_present ? lookup(local.child_types[var.type], "suffix_template", "") : ""

  # construct child naming template
  child_template = local.is_child_type_present ? "${local.prefix_templates[local.prefix_index]}${local.suffix_template}" : ""

  # template at the parent resource or constructed from child naming prefix/suffix patterns
  template = local.is_child_type_present ? local.child_template : local.resource_naming.type[var.type].template

  name_without_type_replacement = var.type == "vm" ? lookup(var.name_sections, "number_suffix") : "-${local.type}\\d*"
}

# Outputs
locals {
  # generated name
  name = local.set_case_lower ? lower(data.template_file.gc_name.rendered) : data.template_file.gc_name.rendered

  type        = var.type != "generic" ? var.type : lookup(var.name_sections, "type", "")
  device_type = local.set_case_lower ? lower(var.device_type) : var.device_type

  prefix = local.set_case_lower ? lower(var.gc_prefix) : var.gc_prefix
}