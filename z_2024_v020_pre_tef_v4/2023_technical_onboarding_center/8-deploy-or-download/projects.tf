module "cs-vpc-host-prod-hh015-gz357" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "vpc-host-prod"
  project_id = "vpc-host-prod-hh015-gz357"
  org_id     = var.org_id
  folder_id  = module.cs-common.id

  billing_account                = var.billing_account
  enable_shared_vpc_host_project = true
}

module "cs-vpc-host-nonprod-hh015-gz357" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "vpc-host-nonprod"
  project_id = "vpc-host-nonprod-hh015-gz357"
  org_id     = var.org_id
  folder_id  = module.cs-common.id

  billing_account                = var.billing_account
  enable_shared_vpc_host_project = true
}

module "cs-logging-hh015-gz357" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "logging"
  project_id = "logging-hh015-gz357"
  org_id     = var.org_id
  folder_id  = module.cs-common.id

  billing_account = var.billing_account
}

module "cs-monitoring-prod-hh015-gz357" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "monitoring-prod"
  project_id = "monitoring-prod-hh015-gz357"
  org_id     = var.org_id
  folder_id  = module.cs-common.id

  billing_account = var.billing_account
}

module "cs-monitoring-nonprod-hh015-gz357" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "monitoring-nonprod"
  project_id = "monitoring-nonprod-hh015-gz357"
  org_id     = var.org_id
  folder_id  = module.cs-common.id

  billing_account = var.billing_account
}

module "cs-monitoring-dev-hh015-gz357" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "monitoring-dev"
  project_id = "monitoring-dev-hh015-gz357"
  org_id     = var.org_id
  folder_id  = module.cs-common.id

  billing_account = var.billing_account
}
