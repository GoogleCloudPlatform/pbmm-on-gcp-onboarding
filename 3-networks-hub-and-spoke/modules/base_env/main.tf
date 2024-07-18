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
  bgp_asn_number      = var.enable_partner_interconnect ? "16550" : "64514"
  // enable_transitivity = var.enable_hub_and_spoke_transitivity

  /*
   * Base network ranges
   */
  /** MRo: TODO remove unused
  //base_subnet_aggregates = ["10.0.0.0/18", "10.1.0.0/18", "100.64.0.0/18", "100.65.0.0/18"]
  //base_hub_subnet_ranges = ["10.0.0.0/24", "10.1.0.0/24"]
  //***/
  /*
   * Restricted network ranges
   */
  /** MRo: TODO remove unused
  //restricted_subnet_aggregates = ["10.8.0.0/18", "10.9.0.0/18", "100.72.0.0/18", "100.73.0.0/18"]
  //restricted_hub_subnet_ranges = ["10.8.0.0/24", "10.9.0.0/24"]
  ***/

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
  // restricted_enabled  = try(data.terraform_remote_state.bootstrap.outputs.common_config.restricted_enabled,false)
  restricted_enabled = module.env_enabled.restricted_enabled

  restricted_services = length(var.custom_restricted_services) != 0 ? var.custom_restricted_services : local.supported_restricted_service
  // MRo: pr_option_seule_region
  // MRo: TODO subnets should come from top level config w/o hardcoding subnet_private_access and subnet_flow_logs
  spoke_config        = module.vpc_config.spoke_config
  environment_code    = local.spoke_config.vpc_config.env_code
  mode                = local.spoke_config.vpc_config.mode

  default_region1     = local.spoke_config.regions.region1.default
  default_region2     = local.spoke_config.regions.region2.default
  region1_enabled     = local.spoke_config.regions.region1.enabled
  region2_enabled     = local.spoke_config.regions.region2.enabled

  subnet_base                     = local.spoke_config.base.subnets
  filtered_subnet_base            = local.spoke_config.base.filtered_subnets
  base_private_service_cidr       = try(local.spoke_config.base.private_service_cidr, null)
  base_private_service_connect_ip = try(local.spoke_config.base.private_service_connect_ip, null)
  base_vpc_routes                 = try(local.spoke_config.base.vpc_routes, null)
  secondary_base_subnets          = try(local.spoke_config.base.secondary_ranges, null)
  filtered_base_subnets_names     = local.spoke_config.base.filtered_subnets_names
  filtered_base_subnets_ips       = local.spoke_config.base.filtered_subnets_ips


  subnet_restricted                     = try(local.restricted_enabled ? local.spoke_config.restricted.subnets : [],[])
  filtered_subnet_restricted            = try(local.restricted_enabled ? local.spoke_config.restricted.filtered_subnets : [], [])
  restricted_private_service_cidr       = try(local.restricted_enabled ? local.spoke_config.restricted.private_service_cidr : null, null)
  restricted_private_service_connect_ip = try(local.restricted_enabled ? local.spoke_config.restricted.private_service_connect_ip : null, null)
  restricted_vpc_routes                 = try(local.restricted_enabled ? local.spoke_config.restricted.vpc_routes : [], [])
  secondary_restricted_subnets          = try(local.restricted_enabled ? local.spoke_config.restricted.secondary_ranges : [], [])
  filtered_restricted_subnets_names     = try(local.restricted_enabled ? local.spoke_config.restricted.filtered_subnets_names : [], [])
  filtered_restricted_subnets_ips       = try(local.restricted_enabled ? local.spoke_config.restricted.filtered_subnets_ips : [], [])


  nat_enabled         = local.spoke_config.nat_enabled
  router_ha_enabled   = local.spoke_config.router_ha_enabled

  base_subnet_self_links       = module.base_shared_vpc[0].subnets_self_links
  restricted_subnet_self_links = try(local.restricted_enabled ? module.restricted_shared_vpc[0].subnets_self_links : [], [])

  sl_base_subnets_split = { for one_subnet_selflink in local.base_subnet_self_links:
       one_subnet_selflink => {
        project_name = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "projects", ) + 1, )
        region_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "regions") + 1, )
        subnet_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "subnetworks") + 1, )
       }
  }
  sl_restricted_subnets_split = try(local.restricted_enabled ? { for one_subnet_selflink in local.restricted_subnet_self_links:
       one_subnet_selflink => {
        project_name = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "projects", ) + 1, )
        region_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "regions") + 1, )
        subnet_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "subnetworks") + 1, )
       }
  } : {},{})

  sl_base_subnets_by_srvprj = {
    for one_subnet_selflink in local.base_subnet_self_links:
      one_subnet_selflink => flatten([
        for one_subnet in local.subnet_base: {
          for one_srv_project in (contains(keys(one_subnet),"service_projects") ? one_subnet.service_projects : [] ) :
            one_srv_project.id => {
              srv_project_id   = one_srv_project.id
              srv_project_mode = one_srv_project.mode
              srv_host_project = local.sl_base_subnets_split[one_subnet_selflink].project_name
              snet_region_id   = one_subnet.region_id
             }  if ( one_subnet.subnet_name == local.sl_base_subnets_split[one_subnet_selflink].subnet_name &&
                     one_subnet.subnet_region == local.sl_base_subnets_split[one_subnet_selflink].region_name )
        }
      ])
  }

  sl_restricted_subnets_by_srvprj = try(local.restricted_enabled ? {
    for one_subnet_selflink in local.restricted_subnet_self_links:
      one_subnet_selflink => flatten([
        for one_subnet in local.subnet_restricted: {
          for one_srv_project in (contains(keys(one_subnet),"service_projects") ? one_subnet.service_projects : [] ) :
             one_srv_project.id => {
              srv_project_id   = one_srv_project.id
              srv_project_mode = one_srv_project.mode
              srv_host_project = local.sl_restricted_subnets_split[one_subnet_selflink].project_name
              snet_region_id   = one_subnet.region_id
             }  if ( one_subnet.subnet_name == local.sl_restricted_subnets_split[one_subnet_selflink].subnet_name &&
                     one_subnet.subnet_region == local.sl_restricted_subnets_split[one_subnet_selflink].region_name )
        }
      ])
  } : {},{})

}

module "env_enabled" {
  source = "../../modules/env_enabled"
  remote_state_bucket = var.remote_state_bucket
}

module "vpc_config" {
  source = "../../modules/nhas_config/vpc_config"
  env  = var.env
  config_file = abspath("${path.module}/../../../config/vpc_config.yaml")
  restricted_enabled = local.restricted_enabled
}


/******************************************
 Restricted shared VPC
*****************************************/
module "restricted_shared_vpc" {
  source = "../restricted_shared_vpc"
  count  = length(local.subnet_restricted) > 0 && local.restricted_enabled ? 1 : 0
  project_id                        = local.restricted_project_id
  project_number                    = local.restricted_project_number
  dns_hub_project_id                = local.dns_hub_project_id
  restricted_net_hub_project_id     = local.restricted_net_hub_project_id
  restricted_net_hub_project_number = local.restricted_net_hub_project_number
  environment_code                  = var.environment_code
  access_context_manager_policy_id  = var.access_context_manager_policy_id
  restricted_services               = local.restricted_services
  members = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
  ], var.perimeter_additional_members))


  ingress_policies           = var.ingress_policies
  egress_policies            = var.egress_policies
  bgp_asn_subnet             = local.bgp_asn_number
  domain                     = var.domain
  mode                       = local.mode


  // MRo:
  subnets          = local.filtered_subnet_restricted
  secondary_ranges = local.secondary_restricted_subnets
  // MRo: added
  default_region1 = local.default_region1
  default_region2 = local.default_region2
  region1_enabled = local.region1_enabled
  region2_enabled = local.region2_enabled
  private_service_cidr       = local.restricted_private_service_cidr
  private_service_connect_ip = local.restricted_private_service_connect_ip
  nat_enabled     = local.nat_enabled
  router_ha_enabled = local.router_ha_enabled
  vpc_routes      = local.restricted_vpc_routes
}

/******************************************
 Base shared VPC
*****************************************/

module "base_shared_vpc" {
  source = "../base_shared_vpc"
  count  = length(local.subnet_base) > 0 ? 1 : 0
  project_id                 = local.base_project_id
  dns_hub_project_id         = local.dns_hub_project_id
  base_net_hub_project_id    = local.base_net_hub_project_id
  environment_code           = var.environment_code
  domain                     = var.domain
  bgp_asn_subnet             = local.bgp_asn_number
  mode                       = local.mode

  subnets          = local.filtered_subnet_base

  secondary_ranges = local.secondary_base_subnets
  // MRo: added
  default_region1 = local.default_region1
  default_region2 = local.default_region2
  region1_enabled = local.region1_enabled
  region2_enabled = local.region2_enabled
  private_service_cidr       = local.base_private_service_cidr
  private_service_connect_ip = local.base_private_service_connect_ip
  nat_enabled       = local.nat_enabled
  router_ha_enabled = local.router_ha_enabled
  vpc_routes        = local.base_vpc_routes
}
