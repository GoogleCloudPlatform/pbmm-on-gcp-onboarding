/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  local_policy_list = {
    "constraints/gcp.resourceLocations" = {
      inherit_from_parent = null
      suggested_value     = "northamerica-northeast1"
      status              = false
      # The policies for location does not work with explicit deny rules,
      values = ["in:asia-locations", "in:australia-locations", "in:europe-locations", "in:us-locations", "in:southamerica-locations"]
    }
    "constraints/compute.vmExternalIpAccess" = {
      inherit_from_parent = null
      status              = false
      suggested_value     = ""
      values              = var.vms_allowed_with_external_ip
    }
    "constraints/compute.vmCanIpForward" = {
      inherit_from_parent = null
      status              = false
      suggested_value     = ""
      values              = var.vms_allowed_with_ip_forward
    }
  }

  local_policy_boolean = {
    "constraints/storage.uniformBucketLevelAccess"      = true
    "constraints/compute.skipDefaultNetworkCreation"    = true
    "constraints/compute.requireOsLogin"                = true
    "constraints/compute.disableNestedVirtualization"   = true
    "constraints/compute.disableSerialPortAccess"       = true
    "constraints/compute.disableGuestAttributesAccess"  = true
    "constraints/compute.restrictXpnProjectLienRemoval" = true
    "constraints/sql.restrictPublicIp"                  = true
    "constraints/iam.disableServiceAccountKeyCreation"  = false
  }

  default_policy_list    = var.set_default_policy == true ? local.local_policy_list : {}
  default_policy_boolean = var.set_default_policy == true ? local.local_policy_boolean : {}
}
