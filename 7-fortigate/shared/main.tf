### GCP terraform for HA setup
terraform {
  required_version = ">=0.12.0"
  required_providers {
    google      = ">=2.11.0"
    google-beta = ">=2.13"
  }
}
provider "google" {
  project = local.vpc_private_network_project_id
  region  = local.default_region
  zone    = var.zone
}
provider "google-beta" {
  project = local.vpc_private_network_project_id
  region  = local.default_region
  zone    = var.zone
}

# Randomize string to avoid duplication
resource "random_string" "random_name_post" {
  length           = 3
  special          = true
  override_special = ""
  min_lower        = 3
}

# Create log disk for active
resource "google_compute_disk" "logdisk" {
  name = "log-disk-${random_string.random_name_post.result}"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

# Create log disk for passive
resource "google_compute_disk" "logdisk2" {
  name = "log-disk2-${random_string.random_name_post.result}"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

########### Network Related
### VPC ###
resource "google_compute_network" "vpc_public" {
  name                    = "vpc-c-shared-public-${random_string.random_name_post.result}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_sync" {
  name                    = "vpc-c-shared-hasync-${random_string.random_name_post.result}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_management" {
  name                    = "vpc-c-shared-mgmt-${random_string.random_name_post.result}"
  auto_create_subnetworks = false
}

# Note the private or internal subnet has already been created by other processes

### Public Subnet ###
resource "google_compute_subnetwork" "public_subnet" {
  name                     = "public-subnet-${random_string.random_name_post.result}"
  region                   = local.default_region
  network                  = google_compute_network.vpc_public.name
  ip_cidr_range            = var.public_subnet
  private_ip_google_access = true
}

### HA Sync Subnet ###
resource "google_compute_subnetwork" "sync_subnet" {
  name                     = "sync-subnet-${random_string.random_name_post.result}"
  region                   = local.default_region
  network                  = google_compute_network.vpc_sync.name
  ip_cidr_range            = var.sync_subnet
  private_ip_google_access = true
}
### HA MGMT Subnet ###
resource "google_compute_subnetwork" "mgmt_subnet" {
  name                     = "mgmt-subnet-${random_string.random_name_post.result}"
  region                   = local.default_region
  network                  = google_compute_network.vpc_management.name
  ip_cidr_range            = var.mgmt_subnet
  private_ip_google_access = true
}

### LZ Management Subnet ###
#resource "google_compute_subnetwork" "lz_mgmt_subnet" {
#  name                     = "lz-mgmt-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  network                  = local.vpc_private_network
#  ip_cidr_range            = local.mgmt_pri_snet_range
#  private_ip_google_access = true
#}

### LZ Identity Subnet ###
#resource "google_compute_subnetwork" "lz_iden_subnet" {
#  name                     = "lz-iden-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  network                  = local.vpc_private_network
#  ip_cidr_range            = local.iden_pri_snet_range
#  private_ip_google_access = true
#}

### Production Public Subnet ###
#resource "google_compute_subnetwork" "prod_pub_subnet" {
#  name                     = "prod-pub-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.prod_vpc_project_id
#  network                  = local.prod_vpc_name
#  ip_cidr_range            = local.prod_pub_snet_range
#  private_ip_google_access = true
#}

### Production Application Subnet ###
#resource "google_compute_subnetwork" "prod_app_subnet" {
#  name                     = "prod-app-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.prod_vpc_project_id
#  network                  = local.prod_vpc_name
#  ip_cidr_range            = local.prod_app_snet_range
#  private_ip_google_access = true
#}

### Production Data Subnet ###
#resource "google_compute_subnetwork" "prod_data_subnet" {
#  name                     = "prod-data-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.prod_vpc_project_id
#  network                  = local.prod_vpc_name
#  ip_cidr_range            = local.prod_data_snet_range
#  private_ip_google_access = true
#}
#
#### Nonproduction Public Subnet ###
#resource "google_compute_subnetwork" "nprod_pub_subnet" {
#  name                     = "nprod-pub-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.nprod_vpc_project_id
#  network                  = local.nprod_vpc_name
#  ip_cidr_range            = local.nprod_pub_snet_range
#  private_ip_google_access = true
#}

### Nonproduction Application Subnet ###
#resource "google_compute_subnetwork" "nprod_app_subnet" {
#  name                     = "nprod-app-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.nprod_vpc_project_id
#  network                  = local.nprod_vpc_name
#  ip_cidr_range            = local.nprod_app_snet_range
#  private_ip_google_access = true
#}
#
#### Nonproduction Data Subnet ###
#resource "google_compute_subnetwork" "nprod_data_subnet" {
#  name                     = "nprod-data-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.nprod_vpc_project_id
#  network                  = local.nprod_vpc_name
#  ip_cidr_range            = local.nprod_data_snet_range
#  private_ip_google_access = true
#}
#
#### Development Public Subnet ###
#resource "google_compute_subnetwork" "dev_pub_subnet" {
#  name                     = "dev-pub-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.dev_vpc_project_id
#  network                  = local.dev_vpc_name
#  ip_cidr_range            = local.dev_pub_snet_range
#  private_ip_google_access = true
#}
#
#### Development Application Subnet ###
#resource "google_compute_subnetwork" "dev_app_subnet" {
#  name                     = "dev-app-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.dev_vpc_project_id
#  network                  = local.dev_vpc_name
#  ip_cidr_range            = local.dev_app_snet_range
#  private_ip_google_access = true
#}
#
#### Development Data Subnet ###
#resource "google_compute_subnetwork" "dev_data_subnet" {
#  name                     = "dev-data-subnet-${random_string.random_name_post.result}"
#  region                   = local.default_region
#  project                  = local.dev_vpc_project_id
#  network                  = local.dev_vpc_name
#  ip_cidr_range            = local.dev_data_snet_range
#  private_ip_google_access = true
#}

resource "google_compute_route" "internal" {
  description  = "internal route to ILB"
  name         = "int-route-ilb-${random_string.random_name_post.result}"
  dest_range   = "0.0.0.0/0"
  network      = local.vpc_private_network_self_link
  next_hop_ilb = google_compute_forwarding_rule.internal_load_balancer.ip_address
  priority     = 100
  depends_on = [
    google_compute_forwarding_rule.internal_load_balancer
  ]
}

# TODO START HERE
# mgmt and ident snet ranges


# Firewall Rule External
resource "google_compute_firewall" "allow-fgt" {
  name    = "allow-fgt-${random_string.random_name_post.result}"
  network = google_compute_network.vpc_public.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-fgt"]
}

# Firewall Rule Internal
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal-${random_string.random_name_post.result}"
  network = local.vpc_private_network_self_link

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-internal"]
}

# Firewall Rule HA SYNC
resource "google_compute_firewall" "allow-sync" {
  name    = "allow-sync-${random_string.random_name_post.result}"
  network = google_compute_network.vpc_sync.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-sync"]
}

# Firewall Rule HA MGMT
resource "google_compute_firewall" "allow-mgmt" {
  name    = "allow-mgmt-${random_string.random_name_post.result}"
  network = google_compute_network.vpc_management.name

  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-mgmt"]
}

########### Router related
resource "google_compute_router" "router" {
  name    = "my-router-${random_string.random_name_post.result}"
  region  = local.default_region
  network = google_compute_network.vpc_public.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat-${random_string.random_name_post.result}"
  router                             = google_compute_router.router.name
  region                             = local.default_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Create static cluster ip
resource "google_compute_address" "static" {
  name = "cluster-ip-${random_string.random_name_post.result}"
}

# Create static active instance management ip
resource "google_compute_address" "static2" {
  name = "activemgmt-ip-${random_string.random_name_post.result}"
}

# Create static passive instance management ip
resource "google_compute_address" "static3" {
  name = "passivemgmt-ip-${random_string.random_name_post.result}"
}

resource "google_project_service" "project" {
  project = local.vpc_private_network_project_id
  service = "iap.googleapis.com"

  disable_on_destroy = false
}

