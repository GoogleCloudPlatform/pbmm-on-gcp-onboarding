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



prod_dns = {
  region1 = "northamerica-northeast1"
  parent = "" # folder/org
  # replace with your on-prem or external DNS server ip
  prod_forward_zone_ipv4_address_1 = "8.8.8.8"
  prod_forward_zone_ipv4_address_2 = "8.8.4.4"
  #billing_account = 
}

#network_self_links = {
#}

#private_visibility_config_networks = [
#    "https://www.googleapis.com/compute/v1/projects/my-project/global/networks/my-vpc"
#  ]
