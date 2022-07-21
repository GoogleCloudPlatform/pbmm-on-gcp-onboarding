/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
