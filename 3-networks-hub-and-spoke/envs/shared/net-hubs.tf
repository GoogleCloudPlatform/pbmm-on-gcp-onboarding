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

locals {
  /*
   * Base network ranges
   */
  supported_restricted_service = [
    "accessapproval.googleapis.com",
    "adsdatahub.googleapis.com",
    "aiplatform.googleapis.com",
    "alloydb.googleapis.com",
    "alpha-documentai.googleapis.com",
    "analyticshub.googleapis.com",
    "apigee.googleapis.com",
    "apigeeconnect.googleapis.com",
    "artifactregistry.googleapis.com",
    "assuredworkloads.googleapis.com",
    "automl.googleapis.com",
    "baremetalsolution.googleapis.com",
    "batch.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigtable.googleapis.com",
    "binaryauthorization.googleapis.com",
    "cloud.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddebugger.googleapis.com",
    "clouddeploy.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudprofiler.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudsearch.googleapis.com",
    "cloudtrace.googleapis.com",
    "composer.googleapis.com",
    "compute.googleapis.com",
    "connectgateway.googleapis.com",
    "contactcenterinsights.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerfilesystem.googleapis.com",
    "containerregistry.googleapis.com",
    "containerthreatdetection.googleapis.com",
    "datacatalog.googleapis.com",
    "dataflow.googleapis.com",
    "datafusion.googleapis.com",
    "datamigration.googleapis.com",
    "dataplex.googleapis.com",
    "dataproc.googleapis.com",
    "datastream.googleapis.com",
    "dialogflow.googleapis.com",
    "dlp.googleapis.com",
    "dns.googleapis.com",
    "documentai.googleapis.com",
    "domains.googleapis.com",
    "eventarc.googleapis.com",
    "file.googleapis.com",
    "firebaseappcheck.googleapis.com",
    "firebaserules.googleapis.com",
    "firestore.googleapis.com",
    "gameservices.googleapis.com",
    "gkebackup.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "healthcare.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iaptunnel.googleapis.com",
    "ids.googleapis.com",
    "integrations.googleapis.com",
    "kmsinventory.googleapis.com",
    "krmapihosting.googleapis.com",
    "language.googleapis.com",
    "lifesciences.googleapis.com",
    "logging.googleapis.com",
    "managedidentities.googleapis.com",
    "memcache.googleapis.com",
    "meshca.googleapis.com",
    "meshconfig.googleapis.com",
    "metastore.googleapis.com",
    "ml.googleapis.com",
    "monitoring.googleapis.com",
    "networkconnectivity.googleapis.com",
    "networkmanagement.googleapis.com",
    "networksecurity.googleapis.com",
    "networkservices.googleapis.com",
    "notebooks.googleapis.com",
    "opsconfigmonitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "osconfig.googleapis.com",
    "oslogin.googleapis.com",
    "privateca.googleapis.com",
    "pubsub.googleapis.com",
    "pubsublite.googleapis.com",
    "recaptchaenterprise.googleapis.com",
    "recommender.googleapis.com",
    "redis.googleapis.com",
    "retail.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "servicecontrol.googleapis.com",
    "servicedirectory.googleapis.com",
    "spanner.googleapis.com",
    "speakerid.googleapis.com",
    "speech.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "storagetransfer.googleapis.com",
    "sts.googleapis.com",
    "texttospeech.googleapis.com",
    "timeseriesinsights.googleapis.com",
    "tpu.googleapis.com",
    "trafficdirector.googleapis.com",
    "transcoder.googleapis.com",
    "translate.googleapis.com",
    "videointelligence.googleapis.com",
    "vision.googleapis.com",
    "visionai.googleapis.com",
    "vmmigration.googleapis.com",
    "vpcaccess.googleapis.com",
    "webrisk.googleapis.com",
    "workflows.googleapis.com",
    "workstations.googleapis.com",
  ]

  restricted_services = length(var.custom_restricted_services) != 0 ? var.custom_restricted_services : local.supported_restricted_service

  net_hub_config      = module.net_hub_config.net_hub_config

  base_subnet_primary_ranges              =  local.net_hub_config.base.subnet_primary_ranges
  base_hub_dns_enable_inbound_forwarding  =  local.net_hub_config.base.hub_dns_enable_inbound_forwarding
  base_hub_dns_enable_logging             =  local.net_hub_config.base.hub_dns_enable_logging
  base_hub_firewall_enable_logging        =  local.net_hub_config.base.hub_firewall_enable_logging
  base_hub_nat_bgp_asn                    =  local.net_hub_config.base.hub_nat_bgp_asn
  base_hub_nat_num_addresses_region1      =  local.net_hub_config.base.hub_nat_num_addresses_region1
  base_hub_nat_num_addresses_region2      =  local.net_hub_config.base.hub_nat_num_addresses_region2
  base_hub_windows_activation_enabled     =  local.net_hub_config.base.hub_windows_activation_enabled
  base_private_service_cidr               =  try(local.net_hub_config.base.private_service_cidr, null)
  base_private_service_connect_ip         =  try(local.net_hub_config.base.private_service_connect_ip, null)
  base_hub_nat_igw_enabled                =  local.net_hub_config.base.hub_nat_igw_enabled
  base_net_hub_vpc_routes                 =  local.net_hub_config.base.net_hub_vpc_routes
  subnet_net_hub_base                     =  local.net_hub_config.base.subnet_net_hub
  secondary_base_subnets                  =  local.net_hub_config.base.secondary_subnets

  restricted_subnet_primary_ranges              = try(local.net_hub_config.restricted.subnet_primary_ranges,[])
  restricted_hub_dns_enable_inbound_forwarding  = try(local.net_hub_config.restricted.hub_dns_enable_inbound_forwarding,false)
  restricted_hub_dns_enable_logging             = try(local.net_hub_config.restricted.hub_dns_enable_logging, false)
  restricted_hub_firewall_enable_logging        = try(local.net_hub_config.restricted.hub_firewall_enable_logging, false)
  restricted_hub_nat_bgp_asn                    = try(local.net_hub_config.restricted.hub_nat_bgp_asn, null)
  restricted_hub_nat_num_addresses_region1      = try(local.net_hub_config.restricted.hub_nat_num_addresses_region1, 0)
  restricted_hub_nat_num_addresses_region2      = try(local.net_hub_config.restricted.hub_nat_num_addresses_region2, 0)
  restricted_hub_windows_activation_enabled     = try(local.net_hub_config.restricted.hub_windows_activation_enabled, false)
  restricted_private_service_cidr               = try(local.net_hub_config.restricted.private_service_cidr, null)
  restricted_private_service_connect_ip         = try(local.net_hub_config.restricted.private_service_connect_ip, null)
  restricted_hub_nat_igw_enabled                = try(local.net_hub_config.restricted.hub_nat_igw_enabled, false)
  restricted_net_hub_vpc_routes                 = try(local.net_hub_config.restricted.net_hub_vpc_routes, [])
  subnet_net_hub_restricted                     = try(local.net_hub_config.restricted.subnet_net_hub, [])
  secondary_restricted_subnets                  = try(local.net_hub_config.restricted.secondary_subnets, [])

  net_hub_router_ha_enabled = local.net_hub_config.net_hub_router_ha_enabled


}

module "net_hub_config" {
  source = "../../modules/nhas_config/net_hub_config"
  config_file = abspath("${path.module}/../../../config/vpc_config.yaml")
  restricted_enabled = local.restricted_enabled
}

/******************************************
  Base Network VPC
*****************************************/

module "base_shared_vpc" {
  source = "../../modules/base_shared_vpc"

  project_id                    = local.base_net_hub_project_id
  dns_hub_project_id            = local.dns_hub_project_id
  environment_code              = local.environment_code
  bgp_asn_subnet                = local.bgp_asn_number
  default_region1               = local.default_region1
  default_region2               = local.default_region2
  domain                        = var.domain
  dns_enable_inbound_forwarding = local.base_hub_dns_enable_inbound_forwarding
  dns_enable_logging            = local.base_hub_dns_enable_logging
  firewall_enable_logging       = local.base_hub_firewall_enable_logging
  nat_bgp_asn                   = local.base_hub_nat_bgp_asn
  nat_num_addresses_region1     = local.base_hub_nat_num_addresses_region1
  nat_num_addresses_region2     = local.base_hub_nat_num_addresses_region2
  windows_activation_enabled    = local.base_hub_windows_activation_enabled
  mode                          = "hub"
  subnets                       = local.subnet_net_hub_base
  secondary_ranges              = local.secondary_base_subnets
  // MRo: added
  region1_enabled = local.region1_enabled
  region2_enabled = local.region2_enabled
  private_service_cidr       = local.base_private_service_cidr
  private_service_connect_ip = local.base_private_service_connect_ip
  nat_enabled     = local.base_hub_nat_igw_enabled
  router_ha_enabled = local.net_hub_router_ha_enabled
  vpc_routes      = local.base_net_hub_vpc_routes
  /**** MRo: TODO: replace w/ locals
  subnets = [
    {
      subnet_name                      = "sb-c-shared-base-hub-${local.default_region1}"
      subnet_ip                        = local.base_subnet_primary_ranges[local.default_region1]
      subnet_region                    = local.default_region1
      subnet_private_access            = "true"
      subnet_flow_logs                 = var.base_vpc_flow_logs.enable_logging
      subnet_flow_logs_interval        = var.base_vpc_flow_logs.aggregation_interval
      subnet_flow_logs_sampling        = var.base_vpc_flow_logs.flow_sampling
      subnet_flow_logs_metadata        = var.base_vpc_flow_logs.metadata
      subnet_flow_logs_metadata_fields = var.base_vpc_flow_logs.metadata_fields
      subnet_flow_logs_filter          = var.base_vpc_flow_logs.filter_expr
      description                      = "Base network hub subnet for ${local.default_region1}"
    },
    {
      subnet_name                      = "sb-c-shared-base-hub-${local.default_region2}"
      subnet_ip                        = local.base_subnet_primary_ranges[local.default_region2]
      subnet_region                    = local.default_region2
      subnet_private_access            = "true"
      subnet_flow_logs                 = var.base_vpc_flow_logs.enable_logging
      subnet_flow_logs_interval        = var.base_vpc_flow_logs.aggregation_interval
      subnet_flow_logs_sampling        = var.base_vpc_flow_logs.flow_sampling
      subnet_flow_logs_metadata        = var.base_vpc_flow_logs.metadata
      subnet_flow_logs_metadata_fields = var.base_vpc_flow_logs.metadata_fields
      subnet_flow_logs_filter          = var.base_vpc_flow_logs.filter_expr
      description                      = "Base network hub subnet for ${local.default_region2}"
    },
    {
      subnet_name      = "sb-c-shared-base-hub-${local.default_region1}-proxy"
      subnet_ip        = local.base_subnet_proxy_ranges[local.default_region1]
      subnet_region    = local.default_region1
      subnet_flow_logs = false
      description      = "Base network hub proxy-only subnet for ${local.default_region1}"
      role             = "ACTIVE"
      purpose          = "REGIONAL_MANAGED_PROXY"
    },
    {
      subnet_name      = "sb-c-shared-base-hub-${local.default_region2}-proxy"
      subnet_ip        = local.base_subnet_proxy_ranges[local.default_region2]
      subnet_region    = local.default_region2
      subnet_flow_logs = false
      description      = "Base network hub proxy-only subnet for ${local.default_region2}"
      role             = "ACTIVE"
      purpose          = "REGIONAL_MANAGED_PROXY"
    }
  ]
  secondary_ranges = {}
  ***/
  depends_on = [module.dns_hub_vpc]
}

/******************************************
  Restricted Network VPC
*****************************************/

module "restricted_shared_vpc" {
  source = "../../modules/restricted_shared_vpc"
  count  = local.restricted_enabled ? 1 : 0

  project_id                       = local.restricted_net_hub_project_id
  project_number                   = local.restricted_net_hub_project_number
  dns_hub_project_id               = local.dns_hub_project_id
  environment_code                 = local.environment_code
  access_context_manager_policy_id = var.access_context_manager_policy_id
  restricted_services              = local.restricted_services
  members = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
  ], var.perimeter_additional_members))
  bgp_asn_subnet                = local.bgp_asn_number
  default_region1               = local.default_region1
  default_region2               = local.default_region2
  domain                        = var.domain
  dns_enable_inbound_forwarding = local.restricted_hub_dns_enable_inbound_forwarding
  dns_enable_logging            = local.restricted_hub_dns_enable_logging
  firewall_enable_logging       = local.restricted_hub_firewall_enable_logging
  nat_bgp_asn                   = local.restricted_hub_nat_bgp_asn
  nat_num_addresses_region1     = local.restricted_hub_nat_num_addresses_region1
  nat_num_addresses_region2     = local.restricted_hub_nat_num_addresses_region2
  windows_activation_enabled    = local.restricted_hub_windows_activation_enabled
  mode                          = "hub"
  subnets                       = local.subnet_net_hub_restricted

  secondary_ranges = local.secondary_restricted_subnets
  // MRo: added
  region1_enabled = local.region1_enabled
  region2_enabled = local.region2_enabled
  private_service_cidr       = local.restricted_private_service_cidr
  private_service_connect_ip = local.restricted_private_service_connect_ip
  nat_enabled     = local.restricted_hub_nat_igw_enabled
  router_ha_enabled = local.net_hub_router_ha_enabled
  vpc_routes      = local.restricted_net_hub_vpc_routes
  egress_policies = distinct(concat(
    local.dedicated_interconnect_egress_policy,
    var.egress_policies
  ))

  ingress_policies = var.ingress_policies

  depends_on = [module.dns_hub_vpc]
}
