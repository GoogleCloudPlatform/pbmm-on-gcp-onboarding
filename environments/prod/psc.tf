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


###############################################################################
#                        Private Service Connect                              #
###############################################################################

# example from https://github.com/terraform-google-modules/terraform-google-network/tree/master/examples/private_service_connect
module "private_service_connect" {
  source                     = "../../modules/22-private-service-connect"
  project_id                 = module.net-host-prj.project_id# var.project_id
  # need array of subnets 
  # module.net-host-prj.network_name is object with 1 attribute "tlzprod-svpc"
  #    │ var.prod_host_net.networks[0].network_name is "tlzprod-svpc"
  #subnetwork_self_link       = module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name].subnets[0].subnet_name
  #network_self_link          = module.net-host-prj.network_self_link #module.simple_vpc.network_self_link
  #network_self_link          = "projects/${module.net-host-prj.project_id}/regions/northamerica-northeast1/subnetworks/${module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name].subnets[0].subnet_name}"
  #  Can't access attributes on a primitive-typed value (string)
  network_self_link          = "projects/${module.net-host-prj.project_id}/global/networks/${module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name]}"
#                                                                                             module.net-host-prj.network_name[var.prod_host_net.networks[0].network_name]
  private_service_connect_ip = var.prod-interconnect.psc_ip #"10.3.0.5"
  forwarding_rule_target     = "all-apis"
  # unsupported - https://github.com/hashicorp/terraform-provider-google/issues/9758
  region = "northamerica-northeast1" 
}
