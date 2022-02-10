/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# CAF GC naming methodology

# aggregate name generator
data "template_file" "gc_name" {
  template = local.template
  vars = {
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
}
