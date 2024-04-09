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



/******************************************
	Routes
 *****************************************/
resource "google_compute_route" "route" {
  project = var.project_id
  network = var.network_name

  name                   = module.route_name.result
  description            = var.description
  dest_range             = var.destination_range
  next_hop_gateway       = var.next_hop_gateway
  next_hop_ip            = var.next_hop_ip
  next_hop_instance      = var.next_hop_instance
  next_hop_instance_zone = var.next_hop_instance_zone
  next_hop_vpn_tunnel    = var.next_hop_vpn_tunnel
  priority               = var.priority
  tags                   = var.tags

  depends_on = [var.module_depends_on]
}
