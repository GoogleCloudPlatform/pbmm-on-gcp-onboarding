
# Shortened name of region will be added to regional resources names
locals {
  region_short = replace( replace( replace( replace(var.day0.region, "europe-", "eu"), "australia", "au" ), "northamerica", "na"), "southamerica", "sa")
}

data "google_compute_forwarding_rule" "elb" {
  name = reverse( split( "/", var.elb ))[0]
}

resource "fortios_firewall_ippool" "this" {
  name = "gcp-${var.name}-eip"
  type = "overload"
  startip = data.google_compute_forwarding_rule.elb.ip_address
  endip = data.google_compute_forwarding_rule.elb.ip_address
}

resource "fortios_firewall_policy" "allowout" {
  name = "${var.name}-allowout"
  action = "accept"
  inspection_mode = "flow"
  status = "enable"
  utm_status = "enable"
  schedule = var.schedule
  application_list = var.application_list
  av_profile = var.av_profile
  ips_sensor = var.ips_sensor
  webfilter_profile = var.webfilter_profile
  ssl_ssh_profile = var.ssl_ssh_profile
  logtraffic = var.logtraffic

  srcintf {
    name = "port2"
  }
  dstintf {
    name = "port1"
  }
  srcaddr {
    name = var.srcaddr
  }
  dstaddr {
    name = var.dstaddr
  }
  service {
    name = var.service
  }
  nat = "enable"
  ippool = "enable"
  poolname {
    name = fortios_firewall_ippool.this.name
  }
}
