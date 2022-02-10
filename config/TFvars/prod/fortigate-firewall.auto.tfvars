/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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