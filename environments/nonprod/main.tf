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


###############################################################################
#                        Non-Production Network                               #
###############################################################################

# Module used to deploy the VPC Service control defined in nonp-vpc-svc-ctl.auto.tfvars
/*module "vpc-svc-ctl" {
  source                    = "../../modules/vpc-service-controls"
  policy_id                 = data.terraform_remote_state.common.outputs.access_context_manager_policy_id 
  parent_id                 = data.terraform_remote_state.common.outputs.access_context_manager_parent_id 
  regular_service_perimeter = var.nonprod_vpc_svc_ctl.regular_service_perimeter
  bridge_service_perimeter  = var.nonprod_vpc_svc_ctl.bridge_service_perimeter
  department_code           = local.organization_config.department_code
  environment               = local.organization_config.environment
  location                  = local.organization_config.location
  user_defined_string       = data.terraform_remote_state.common.outputs.audit_config.user_defined_string

  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]
}*/

# Module use to deploy a project with a virtual private cloud
module "net-host-prj" {
  source                         = "../../modules/network-host-project"
  services                       = var.nonprod_host_net.services
  billing_account                = local.organization_config.billing_account
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.NonProdNetworking.id
  networks                       = var.nonprod_host_net.networks
  projectlabels                  = var.nonprod_host_net.labels
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.nonprod_host_net.user_defined_string
  additional_user_defined_string = var.nonprod_host_net.additional_user_defined_string
  depends_on = [
    data.terraform_remote_state.common
  ]
}


# Module is used to deploy firewall rules for the network host project 
module "firewall" {
  source          = "../../modules/firewall"
  project_id      = module.net-host-prj.project_id
  network         = module.net-host-prj.network_name[var.nonprod_host_net.networks[0].network_name]
  custom_rules    = var.nonprod_firewall.custom_rules
  department_code = local.organization_config.department_code
  environment     = local.organization_config.environment
  location        = local.organization_config.location
  depends_on = [
    module.net-host-prj
  ]
}

module "nonprod_projects" {
  for_each                       = { for prj in local.nonprod_projects : prj.name => prj }
  source                         = "../../modules/project"
  billing_account                = each.value.billing_account
  department_code                = local.organization_config.department_code
  user_defined_string            = each.value.user_defined_string
  additional_user_defined_string = each.value.additional_user_defined_string
  owner                          = local.organization_config.owner
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  parent                         = data.terraform_remote_state.common.outputs.folders_map_1_levels["Dev"].id
  labels                         = each.value.labels
  services                       = each.value.services
  shared_vpc_service_config      = each.value.shared_vpc_service_config
}

module "nonprod-monitoring-centers" {
  for_each                       = local.merged_monitoring_centers
  source                         = "../../modules/monitoring-center"
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.default_region
  owner                          = local.organization_config.owner
  user_defined_string            = each.value.user_defined_string
  additional_user_defined_string = each.value.additional_user_defined_string
  parent                         = data.terraform_remote_state.common.outputs.folders_map_1_levels["LoggingMonitoring"].id
  billing_account                = local.organization_config.billing_account
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  projectlabels                  = each.value.projectlabels
  project                        = each.value.project
  monitored_projects             = each.value.monitored_projects
  monitoring_viewer_members_list = each.value.monitoring_center_viewers
}

resource "google_project_iam_binding" "nethost_sharedvpc_computesecurityadmin_iambinding" {
  project = module.net-host-prj.project_id
  role    = "roles/compute.securityAdmin"
  members = [
    "serviceAccount:${module.nonprod_projects["gkedemo-dev"].service_accounts.robots.container-engine}",
  ]
}

resource "google_project_iam_binding" "nethost_sharedvpc_hostserviceagentuser_iambinding" {
  project = module.net-host-prj.project_id
  role    = "roles/container.hostServiceAgentUser"
  members = [
    "serviceAccount:${module.nonprod_projects["gkedemo-dev"].service_accounts.robots.container-engine}",
  ]
}

resource "google_project_iam_binding" "nethost_sharedvpc_computesubnetworksuser_iambinding" {
  project = module.net-host-prj.project_id
  role    = "roles/compute.networkUser"
  members = [
    "serviceAccount:${module.nonprod_projects["gkedemo-dev"].service_accounts.robots.container-engine}",
    "serviceAccount:${module.nonprod_projects["gkedemo-dev"].service_accounts.cloud_services}",
  ]
}

module "gkedemo_gkecluster_demo_node_sa" {
  source                = "../../modules/gke-service-account"
  project               = module.nonprod_projects["gkedemo-dev"].project_id
  name                  = "gke-demo-serviceaccount"
  description           = "custom service account for nodes of the demo node group"
  service_account_roles = []
}


module "google_apis_private_zone" {
  source      = "../../modules/dns-zone"
  project_id  = module.net-host-prj.project_id
  type        = "private"
  name        = "google-apis"
  domain      = "googleapis.com."
  description = "The private zone for Google APIs"

  private_visibility_config_networks = [local.shared_vpc_network_selflink]
  dns_policy_network                 = local.shared_vpc_network_selflink
  enable_inbound_forwarding          = true
  enable_logging                     = true

  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "restricted.googleapis.com.",
      ]
    },
    {
      name = "restricted"
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7",
      ]
    }
  ]
}

module "gcr_io_private_zone" {
  source      = "../../modules/dns-zone"
  project_id  = module.net-host-prj.project_id
  type        = "private"
  name        = "gcr-io"
  domain      = "gcr.io."
  description = "The private zone for GCR.io"

  private_visibility_config_networks = [local.shared_vpc_network_selflink]
  dns_policy_network                 = local.shared_vpc_network_selflink
  enable_inbound_forwarding          = false
  enable_logging                     = true

  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "gcr.io.",
      ]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7",
      ]
    }
  ]
}

module "gkedemo_gkecluster" {
  source = "../../modules/gke-cluster"

  project                        = module.nonprod_projects["gkedemo-dev"].project_id
  department_code                = local.organization_config.department_code
  user_defined_string            = "gke"
  additional_user_defined_string = "demo"
  description                    = "GKE cluster for demo in DEV"
  owner                          = local.organization_config.owner
  environment                    = local.organization_config.environment
  # location                       = local.organization_config.location
  location = "${local.organization_config.location}-a"
  # node_locations                 = ["${local.organization_config.location}-a"]
  kubernetes_version = "1.23.13-gke.900"

  network                       = local.shared_vpc_network_selflink
  subnetwork                    = local.shared_vpc_subnetwork_selflink
  cluster_secondary_range_name  = var.nonprod_host_net.networks[0].subnets[0].secondary_ranges[0].range_name
  services_secondary_range_name = var.nonprod_host_net.networks[0].subnets[0].secondary_ranges[1].range_name
  default_node_tags             = var.nonprod_firewall.custom_rules.allow-egress-internet.targets
  enable_private_nodes          = true
  master_ipv4_cidr_block        = "172.16.0.0/28"

  secrets_encryption_kms_key = module.nonprod_projects["gkedemo-dev"].default_regional_customer_managed_key_id

  resource_labels = {
    owner = "jacksonyang"
  }
  node_pools = {
    demo = {
      name = "demo"
      # node_locations     = ["${local.organization_config.location}-a"]
      initial_node_count = 1
      min_node_count     = 0
      max_node_count     = 3
      preemptible        = false
      service_account    = module.gkedemo_gkecluster_demo_node_sa.email
      boot_disk_kms_key  = module.nonprod_projects["gkedemo-dev"].default_regional_customer_managed_key_id
      tags               = concat(var.nonprod_firewall.custom_rules.allow-egress-internet.targets, var.nonprod_host_net.networks[0].routes[1].tags)
      labels = {
        app = "demo"
        env = "dev"
      }
      taint = [{
        key    = "app"
        value  = "demo"
        effect = "PREFER_NO_SCHEDULE"
        # effect = "NO_SCHEDULE"
        },
        {
          key    = "env"
          value  = "dev"
          effect = "PREFER_NO_SCHEDULE"
          # effect = "NO_SCHEDULE"
      }]
    }
  }
  depends_on = [
    google_project_iam_binding.nethost_sharedvpc_computesecurityadmin_iambinding,
    google_project_iam_binding.nethost_sharedvpc_hostserviceagentuser_iambinding,
    google_project_iam_binding.nethost_sharedvpc_computesubnetworksuser_iambinding,
  ]
}

module "gke_cluster_helmchart_deployer" {
  source   = "../../modules/gke-helmchart-deployer"
  project  = module.nonprod_projects["gkedemo-dev"].project_id
  location = "${local.organization_config.location}-a"
  name     = module.gkedemo_gkecluster.name
  helmchart_applications = {
    nginx = {
      name       = "nginx"
      chart      = "nginx"
      repository = "https://charts.bitnami.com/bitnami"
    }
  }
}
