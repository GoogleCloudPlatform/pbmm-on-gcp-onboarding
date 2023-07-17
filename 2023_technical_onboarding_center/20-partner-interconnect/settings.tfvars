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

# VPC where the routers and interconnect reside
vpc_name = "vpc-nonprod-shared"

# currently defaulted - uncomment to set
region1 = "northamerica-northeast2"
#region1_router1_name = "router1"
#region1_router2_name = "router2"
preactivate = true

region1_vlan1_name = "vlan-attach-cologix-1"
region1_vlan2_name = "vlan-attach-cologix-2"
region1_vlan3_name = "vlan-attach-equinix-3"
region1_vlan4_name = "vlan-attach-equinix-4"



