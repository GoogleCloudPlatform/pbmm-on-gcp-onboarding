
locals {
  env_code = substr(var.env, 0, 1)

}

data "google_netblock_ip_ranges" "legacy_health_checkers" {
  range_type = "legacy-health-checkers"
}

data "google_netblock_ip_ranges" "health_checkers" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

module "peering_network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id                             = var.peering_project_id
  network_name                           = "vpc-${local.env_code}-peering-base"
  shared_vpc_host                        = "false"
  delete_default_internet_gateway_routes = "true"
  /****** MRo: not good
  subnets = [
    {
      subnet_name                      = "sb-${local.env_code}-${var.business_code}-peered-${var.subnet_region}"
      subnet_ip                        = var.subnet_ip_range
      subnet_region                    = var.subnet_region
      subnet_private_access            = "true"
      description                      = "Peered subnetwork on region ${var.subnet_region}."
      subnet_flow_logs                 = "true"
      subnet_flow_logs_interval        = var.vpc_flow_logs.aggregation_interval
      subnet_flow_logs_sampling        = var.vpc_flow_logs.flow_sampling
      subnet_flow_logs_metadata        = var.vpc_flow_logs.metadata
      subnet_flow_logs_metadata_fields = var.vpc_flow_logs.metadata_fields
      subnet_flow_logs_filter          = var.vpc_flow_logs.filter_expr
    }
  ]
  ************/
  subnets = [ for one_subnet_region in keys(var.subnet_config) : {
      subnet_name                      = "sb-${local.env_code}-${var.business_code}-peered-${one_subnet_region}"
      subnet_ip                        = var.subnet_config[one_subnet_region]
      subnet_region                    = one_subnet_region
      subnet_private_access            = "true"
      description                      = "Peered subnetwork on region ${one_subnet_region}."
      subnet_flow_logs                 = "true"
      subnet_flow_logs_interval        = var.vpc_flow_logs.aggregation_interval
      subnet_flow_logs_sampling        = var.vpc_flow_logs.flow_sampling
      subnet_flow_logs_metadata        = var.vpc_flow_logs.metadata
      subnet_flow_logs_metadata_fields = var.vpc_flow_logs.metadata_fields
      subnet_flow_logs_filter          = var.vpc_flow_logs.filter_expr
  }

  ]
}

resource "google_dns_policy" "default_policy" {
  project                   = var.peering_project_id
  name                      = "dp-${local.env_code}-peering-base-default-policy"
  enable_inbound_forwarding = true
  enable_logging            = true
  networks {
    network_url = module.peering_network.network_self_link
  }
}

module "peering" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 9.0"

  prefix            = "${var.business_code}-${local.env_code}"
  local_network     = module.peering_network.network_self_link
  peer_network      = var.peer_network_self_link
  module_depends_on = var.peering_module_depends_on
}
/******************************************
  Mandatory and optional firewall rules
 *****************************************/
module "firewall_rules" {
  source      = "terraform-google-modules/network/google//modules/network-firewall-policy"
  version     = "~> 9.0"
  project_id  = var.peering_project_id
  policy_name = "fp-${local.env_code}-peering-project-firewalls"
  description = "Firewall rules for Peering Network: ${module.peering_network.network_name}."

  rules = concat(
    [
      {
        priority       = "65530"
        direction      = "EGRESS"
        action         = "deny"
        rule_name      = "fw-${local.env_code}-peering-base-65530-e-d-all-all-tcp-udp"
        description    = "Lower priority rule to deny all egress traffic."
        enable_logging = var.firewall_enable_logging
        match = {
          dest_ip_ranges = ["0.0.0.0/0"]
          layer4_configs = [
            {
              ip_protocol = "tcp"
            },
            {
              ip_protocol = "udp"
            },
          ]
        }
      },
      {
        priority       = "10000"
        direction      = "EGRESS"
        action         = "allow"
        rule_name      = "fw-${local.env_code}-peering-base-10000-e-a-allow-google-apis-all-tcp-443"
        description    = "Lower priority rule to allow private google apis on TCP port 443."
        enable_logging = var.firewall_enable_logging
        match = {
          dest_ip_ranges = ["199.36.153.8/30"]
          layer4_configs = [
            {
              ip_protocol = "tcp"
              ports       = ["443"]
            },
          ]
        }
      },
      {
        // Allow SSH via IAP when using the ssh-iap-access/allow resource manager tag for Linux workloads.
        rule_name          = "fw-${local.env_code}-peering-base-1000-i-a-all-allow-iap-ssh-tcp-22"
        action             = "allow"
        direction          = "INGRESS"
        priority           = "1000"
        enable_logging     = true
        target_secure_tags = var.peering_iap_fw_rules_enabled ? try(["tagValues/${google_tags_tag_value.firewall_tag_value_ssh[0].name}"],[]) : []
        match = {
          src_ip_ranges = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
          layer4_configs = [
            {
              ip_protocol = "tcp"
              ports       = ["22"]
            },
          ]
        }
      },
      {
        // Allow RDP via IAP when using the rdp-iap-access/allow resource manager tag for Windows workloads.
        rule_name          = "fw-${local.env_code}-peering-base-1001-i-a-all-allow-iap-rdp-tcp-3389"
        action             = "allow"
        direction          = "INGRESS"
        priority           = "1001"
        enable_logging     = true
        target_secure_tags = var.peering_iap_fw_rules_enabled ? try(["tagValues/${google_tags_tag_value.firewall_tag_value_rdp[0].name}"],[]) : []
        match = {
          src_ip_ranges = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
          layer4_configs = [
            {
              ip_protocol = "tcp"
              ports       = ["3389"]
            },
          ]
        }
      }
    ],
    !var.windows_activation_enabled ? [] : [
      {
        priority       = "0"
        direction      = "EGRESS"
        action         = "allow"
        rule_name      = "fw-${local.env_code}-peering-base-0-e-a-allow-win-activation-all-tcp-1688"
        description    = "Allow access to kms.windows.googlecloud.com for Windows license activation."
        enable_logging = var.firewall_enable_logging
        match = {
          dest_ip_ranges = ["35.190.247.13/32"]
          layer4_configs = [
            {
              ip_protocol = "tcp"
              ports       = ["1688"]
            },
          ]
        }
      }
    ],
    !var.optional_fw_rules_enabled ? [] : [
      {
        priority       = "1000"
        direction      = "INGRESS"
        action         = "allow"
        rule_name      = "fw-${local.env_code}-peering-base-1000-i-a-all-allow-lb-tcp-80-8080-443"
        description    = "Allow traffic for Internal & Global load balancing health check and load balancing IP ranges."
        enable_logging = var.firewall_enable_logging
        match = {
          src_ip_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)
          layer4_configs = [
            {
              // Allow common app ports by default.
              ip_protocol = "tcp"
              ports       = ["80", "8080", "443"]
            },
          ]
        }
      },
    ]
  )

  depends_on = [
    google_tags_tag_value.firewall_tag_value_ssh,
    google_tags_tag_value.firewall_tag_value_rdp
  ]
}

resource "google_compute_network_firewall_policy_association" "vpc_association" {
  name              = "${module.firewall_rules.fw_policy[0].name}-${module.peering_network.network_name}"
  attachment_target = module.peering_network.network_id
  firewall_policy   = module.firewall_rules.fw_policy[0].id
  project           = var.peering_project_id

  depends_on = [
    module.firewall_rules,
    module.peering_network
  ]
}

resource "google_tags_tag_key" "firewall_tag_key_ssh" {
  count = var.peering_iap_fw_rules_enabled ? 1 : 0

  short_name = "ssh-iap-access"
  parent     = "projects/${var.peering_project_id}"
  purpose    = "GCE_FIREWALL"

  purpose_data = {
    network = "${var.peering_project_id}/${module.peering_network.network_name}"
  }
}

resource "google_tags_tag_value" "firewall_tag_value_ssh" {
  count = var.peering_iap_fw_rules_enabled ? 1 : 0

  short_name = "allow"
  parent     = "tagKeys/${google_tags_tag_key.firewall_tag_key_ssh[0].name}"
}

resource "google_tags_tag_key" "firewall_tag_key_rdp" {
  count = var.peering_iap_fw_rules_enabled ? 1 : 0

  short_name = "rdp-iap-access"
  parent     = "projects/${var.peering_project_id}"
  purpose    = "GCE_FIREWALL"

  purpose_data = {
    network = "${var.peering_project_id}/${module.peering_network.network_name}"
  }
}

resource "google_tags_tag_value" "firewall_tag_value_rdp" {
  count = var.peering_iap_fw_rules_enabled ? 1 : 0

  short_name = "allow"
  parent     = "tagKeys/${google_tags_tag_key.firewall_tag_key_rdp[0].name}"
}
