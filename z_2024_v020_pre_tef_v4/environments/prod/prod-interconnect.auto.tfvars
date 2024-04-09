/**
 * Copyright 2023 Google LLC
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

prod-interconnect = {
  interconnect_router_name = "interconnect-prod-router"

  # currently defaulted - uncomment to set
  region1 = "northamerica-northeast1"

  preactivate = true

  region1_vlan1_name = "vlan-attach-cologix-1"
  region1_vlan2_name = "vlan-attach-cologix-2"
  region1_vlan3_name = "vlan-attach-equinix-3"
  region1_vlan4_name = "vlan-attach-equinix-4"
  psc_ip = "10.3.0.5"
}
