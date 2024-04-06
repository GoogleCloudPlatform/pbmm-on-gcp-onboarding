# VPC and Subnets
module "cs-vpc-prod-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.cs-vpc-host-prod-hh015-gz357.project_id
  network_name = "vpc-prod-shared"

  subnets = [
    {
      subnet_name           = "subnet-prod-1"
      subnet_ip             = "10.1.0.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "subnet-prod-2"
      subnet_ip             = "10.2.0.0/24"
      subnet_region         = "northamerica-northeast2"
      subnet_private_access = true
    },
  ]

  firewall_rules = [
    {
      name      = "vpc-prod-shared-allow-icmp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [{
        protocol = "icmp"
        ports    = []
        }
      ]

      ranges = [
        "10.128.0.0/9",
      ]
    },
    {
      name      = "vpc-prod-shared-allow-ssh"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [{
        protocol = "tcp"
        ports    = ["22"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
    {
      name      = "vpc-prod-shared-allow-rdp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [{
        protocol = "tcp"
        ports    = ["3389"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
  ]
}


# VPC and Subnets
module "cs-vpc-nonprod-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.cs-vpc-host-nonprod-hh015-gz357.project_id
  network_name = "vpc-nonprod-shared"

  subnets = [
    {
      subnet_name           = "subnet-non-prod-1"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "subnet-non-prod-2"
      subnet_ip             = "10.20.0.0/16"
      subnet_region         = "northamerica-northeast2"
      subnet_private_access = true
    },
  ]

  firewall_rules = [
    {
      name      = "vpc-nonprod-shared-allow-icmp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [{
        protocol = "icmp"
        ports    = []
        }
      ]

      ranges = [
        "10.128.0.0/9",
      ]
    },
    {
      name      = "vpc-nonprod-shared-allow-ssh"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [{
        protocol = "tcp"
        ports    = ["22"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
    {
      name      = "vpc-nonprod-shared-allow-rdp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [{
        protocol = "tcp"
        ports    = ["3389"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
  ]
}


