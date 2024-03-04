
# Shortened name of region will be added to regional resources names
locals {
  region_short = replace( replace( replace( replace(var.day0.region, "europe-", "eu"), "australia", "au" ), "northamerica", "na"), "southamerica", "sa")
}

resource "google_compute_address" "elb_eip" {
  name = "${var.srv_name}-eip-${local.region_short}"
  region = var.day0.region
}

resource "google_compute_forwarding_rule" "elb_frule" {
  name = "${var.srv_name}-fwdrule"
  region = var.day0.region
  ip_address = google_compute_address.elb_eip.self_link
  ip_protocol = "L3_DEFAULT"
  all_ports = true
  load_balancing_scheme = "EXTERNAL"
  backend_service = google_compute_region_backend_service.elb_bes.self_link
}

resource "google_compute_region_backend_service" "elb_bes" {
  provider = google-beta
  name = "${var.day0.prefix}bes-elb-${local.region_short}"
  region = var.day0.region
  load_balancing_scheme = "EXTERNAL"
  protocol = "UNSPECIFIED"

  backend {
    group = var.day0.fgt_umigs[0]
  }
  backend {
    group = var.day0.fgt_umigs[1]
  }

  health_checks = [var.day0.health_check]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}

resource "google_compute_route" "default_route" {
  name = "${var.day0.prefix}rt-default-via-fgt"
  dest_range = "0.0.0.0/0"
  network = var.day0.internal_vpc
  next_hop_ilb = var.day0.ilb
  priority = 100
}

# configure probes
# Note that we need to use the loopback interface so the use-case terraform_version
# configuration is destroyable (nopt possible if we used secondary ip)
data "fortios_system_interface" "probe" {
  name = "probe"
}
data "fortios_system_proberesponse" "probe" {}

resource "fortios_firewall_vip" "vip_probe" {
  name = "${var.srv_name}-probe"
  extintf = "port1"
  extip = google_compute_address.elb_eip.address
  portforward = "enable"
  extport = data.fortios_system_proberesponse.probe.port
  mappedport = data.fortios_system_proberesponse.probe.port
  mappedip {
    range = split(" ", data.fortios_system_interface.probe.ip)[0]
  }
}

resource "fortios_firewallservice_custom" "service_probe" {
  name = "LB_Probe"
  tcp_portrange = data.fortios_system_proberesponse.probe.port
}

resource "fortios_firewall_policy" "probe_allow" {
  name = "allow-${var.srv_name}-probe"
  action = "accept"
  schedule = "always"
  inspection_mode = "flow"
  status = "enable"

  srcintf {
    name = "port1"
  }
  dstintf {
    name = "probe"
  }
  srcaddr {
    name = "all"
  }
  dstaddr {
    name = fortios_firewall_vip.vip_probe.name
  }
  service {
    name = fortios_firewallservice_custom.service_probe.name
  }
  nat = "disable"
}

# Forwarding the N-S traffic
resource "fortios_firewall_vip" "vip" {
  count = length(var.targets)

  name = "${var.srv_name}-tcp${var.targets[count.index].port}"
  extintf = "port1"
  extip = google_compute_address.elb_eip.address
  portforward = "enable"
  extport = var.targets[count.index].port
  mappedport = var.targets[count.index].mappedport

  mappedip {
    range = var.targets[count.index].ip
  }
}

resource "fortios_firewallservice_custom" "service" {
  count = length(var.targets)

  name = "${var.srv_name}-tcp${var.targets[count.index].mappedport}"
  tcp_portrange = var.targets[count.index].mappedport
}

resource "fortios_firewall_policy" "vip_allow" {
  count = length(var.targets)

  name = "allow-${var.srv_name}-tcp${var.targets[count.index].port}"
  action = "accept"
  schedule = "always"
  inspection_mode = "flow"
  status = "enable"
  logtraffic = var.logtraffic

  srcintf {
    name = "port1"
  }
  dstintf {
    name = "port2"
  }
  srcaddr {
    name = "all"
  }
  dstaddr {
    name = fortios_firewall_vip.vip[count.index].name
  }
  service {
    name = fortios_firewallservice_custom.service[count.index].name
  }
  nat = "disable"
}
