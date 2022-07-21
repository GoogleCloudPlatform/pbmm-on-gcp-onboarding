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



fortigateConfig = {
  network_tags = ["fortigate"]
  machine_type = "n2-standard-4"
  project      = "" # perimeter project name
  network_ports = {
    port1 = {
      port_name  = "port1-public-port"
      project    = "" # perimeter project name
      subnetwork = "" # public subnet name
    }
    port2 = {
      port_name  = "port2-private-port"
      project    = "" # perimeter project name
      subnetwork = "" # private subnet name
    }
    port3 = {
      port_name  = "port3-hasync-port"
      project    = "" # perimeter project name
      subnetwork = "" # ha subnet name
    }
    port4 = {
      port_name  = "port4-management-port"
      project    = "" # perimeter project name
      subnetwork = "" # management subnet name
    }
  }
  public_port         = "port1"
  internal_port       = "port2"
  ha_port             = "port3"
  mgmt_port           = "port4"
  user_defined_string = "firewall"
}