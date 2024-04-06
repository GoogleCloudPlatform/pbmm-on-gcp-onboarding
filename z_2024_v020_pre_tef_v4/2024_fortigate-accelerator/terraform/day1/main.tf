
# Connect the workload VPCs to FortiGate Security Hub
module "peer1" {
  source = "../modules/usecases/spoke-vpc"

  day0 = data.terraform_remote_state.base.outputs
  vpc_name = google_compute_network.tier1.name
  vpc_project = google_compute_network.tier1.project
  spoke_self_link = google_compute_network.tier1.self_link
  spoke_ip_cidr_ranges = ["10.0.0.0/16"]
}

module "peer2" {
  source = "../modules/usecases/spoke-vpc"

  day0 = data.terraform_remote_state.base.outputs
  vpc_name = google_compute_network.tier2.name
  vpc_project = google_compute_network.tier2.project
  spoke_self_link = google_compute_network.tier2.self_link
  spoke_ip_cidr_ranges = ["10.1.0.0/16"]
  depends_on = [
    module.peer1
  ]
}

# Enable inbound connections and redirect port 80 to some workload
module "inbound" {
  source     = "../modules/usecases/inbound-ns"

  day0       = data.terraform_remote_state.base.outputs
  srv_name   = "serv1"
  targets    = [
    {
      ip   = google_compute_address.wrkld_tier1.address,
      port = 80,
      mappedport = 8080
    },
  ]

  # Manual dependency is needed here because of GCP issues with parallel peering and routing
  depends_on = [
    module.peer1
  ]
}

# Output the external IP address of new service
output public_ip {
  value     = module.inbound.public_ip
}

# Enable outbound connections
module "outbound" {
  source    = "../modules/usecases/outbound-ns"

  day0      = data.terraform_remote_state.base.outputs
  elb       = module.inbound.elb_frule
  name      = "serv1"
}

# East-west firewall policy and dynamic addresses
# This block uses directly a firewall policy terreform resource instead of calling a module
resource "fortios_firewall_policy" "tier1-to-tier2" {
  name = "tier1-to-tier2"
  action = "accept"
  inspection_mode = "flow"
  status = "enable"
  utm_status = "enable"
  schedule = "always"
  av_profile = "default"
  ips_sensor = "default"
  logtraffic = "all"

  srcintf {
    name = "port2"
  }
  dstintf {
    name = "port2"
  }
  srcaddr {
    name = fortios_firewall_address.tier1.name
  }
  dstaddr {
    name = fortios_firewall_address.tier2.name
  }
  service {
    name = "HTTP"
  }
}

resource "fortios_firewall_address" "tier1" {
  name = "gcp-tier1"
  type = "dynamic"
  sub_type = "sdn"
  sdn  = "gcp"
  sdn_addr_type = "private"
  filter = "Tag=tier1"
}

resource "fortios_firewall_address" "tier2" {
  name = "gcp-tier2"
  type = "dynamic"
  sub_type = "sdn"
  sdn  = "gcp"
  sdn_addr_type = "private"
  filter = "Tag=tier2"
}
