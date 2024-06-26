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

  restricted_services = length(var.custom_restricted_services) != 0 ? var.custom_restricted_services : local.supported_restricted_service
  // MRo: pr_option_seule_region
  // MRo: TODO subnets should come from top level config w/o hardcoding subnet_private_access and subnet_flow_logs
  /**************** MRo: moved to module
  vpc_config      = var.spoke_config.vpc_config
  mode            = try(local.vpc_config.mode,"spoke")
  env_enabled     = var.spoke_config.env_enabled
  regions_config  = var.spoke_config.regions_config
  region1_enabled = try(local.regions_config.region1.enabled,true)
  region2_enabled = try(local.regions_config.region2.enabled,false)
  default_region1 = try(local.regions_config.region1.name,"none")
  default_region2 = try(local.regions_config.region2.name,"none")
  base_vpc_config = local.vpc_config.base
  restricted_vpc_config = local.vpc_config.restricted
  base_spoke_type = try(local.base_vpc_config.env_type,"shared-base")
  restricted_spoke_type = try(local.restricted_vpc_config.env_type,"shared-restricted")
  base_private_service_connect_ip  =  local.base_vpc_config.private_service_connect_ip
  restricted_private_service_connect_ip = local.restricted_vpc_config.private_service_connect_ip
  base_private_service_cidr = try(local.base_vpc_config.private_service_cidr,null)
  restricted_private_service_cidr = try(local.restricted_vpc_config.private_service_cidr,null)
  nat_igw_enabled = try(local.vpc_config.nat_igw_enabled,false)
  windows_activation_enabled = try(local.vpc_config.windows_activation_enabled,false)
  router_ha_enabled = try(local.vpc_config.router_ha_enabled, false)
  enable_hub_and_spoke_transitivity = try(local.vpc_config.enable_hub_and_spoke_transitivity,false)
  env_code   = local.vpc_config.env_code
  base_vpc_routes =  [ for one_route in var.spoke_config.vpc_routes.base : {
                      for k,v in one_route : ((k == "name_suffix") ? "name" : k) => (k == "name_suffix") ? "rt-${local.env_code}-shared-base-${local.mode}-${v}" : v
                     } if (try(one_route.id,"") != "rt_nat_to_internet" || local.nat_igw_enabled) &&
                       (try(one_route.id,"") != "rt_windows_activation" || local.windows_activation_enabled)
                  ]
  restricted_vpc_routes =  [ for one_route in var.spoke_config.vpc_routes.restricted : {
                      for k,v in one_route : ((k == "name_suffix") ? "name" : k) => (k == "name_suffix") ? "rt-${local.env_code}-shared-restricted-${local.mode}-${v}" : v
                     } if (try(one_route.id,"") != "rt_nat_to_internet" || local.nat_igw_enabled) &&
                       (try(one_route.id,"") != "rt_windows_activation" || local.windows_activation_enabled)
                  ]

  subnet_base = flatten(
     [ for one_subnet in local.vpc_config.base.subnets:
         [ for one_region_id in keys(local.regions_config):
            merge(
                {
                  subnet_name   = "sb-${local.env_code}-${local.base_spoke_type}-${local.regions_config[one_region_id].name}${one_subnet.subnet_suffix}"
                  subnet_ip     = one_subnet.ip_ranges[one_region_id]
                  subnet_region = local.regions_config[one_region_id].name
                  region_id     = one_region_id
                  subnet_private_access = try(one_subnet.private_access,false)
                  subnet_flow_logs      = try(one_subnet.flow_logs.enable,false)
                  description           = try(one_subnet.description, "First ${local.base_spoke_type} subnet example")
                },
              try(contains(keys(one_subnet),"service_projects") ?
                {
                  service_projects = one_subnet.service_projects
                } : null, null
              ),
              try(one_subnet.flow_logs.enable,false) ?
                {
                  subnet_flow_logs_interval = try(one_subnet.flow_logs.interval,var.base_vpc_flow_logs.aggregation_interval)
                  subnet_flow_logs_metadata        = var.base_vpc_flow_logs.metadata
                  subnet_flow_logs_metadata_fields = var.base_vpc_flow_logs.metadata_fields
                  subnet_flow_logs_filter          = var.base_vpc_flow_logs.filter_expr
                } : null,
              try(contains(keys(one_subnet),"role") ?
                {
                  role = one_subnet.role
                } : null,null
              ),
              try(contains(keys(one_subnet),"purpose") ?
                {
                  purpose = one_subnet.purpose
                } : null,null
              ),
              try(contains(keys(one_subnet),"secondary_ranges") ?
                {
                  secondary_ranges = (
                    [ for one_range in one_subnet.secondary_ranges :
                      {
                        range_name = "rn-${local.env_code}-${local.base_spoke_type}-${local.regions_config[one_region_id].name}-${one_range.range_suffix}"
                        ip_cidr_range = try(one_range.ip_cidr_range[one_region_id],null)
                      } if contains(keys(one_range.ip_cidr_range),one_region_id) && ! try(local.regions_config[one_region_id].disabled,false)
                    ])
                } : null, null  )
            )  if (try(!local.regions_config[one_region_id].disabled,true) && try(can(cidrhost(one_subnet.ip_ranges[one_region_id],1)),false)) &&
                   try(local.env_enabled,false) && try(local.vpc_config.base.enabled,false) &&
                   ((one_region_id == "region1" && local.region1_enabled) || (one_region_id == "region2" && local.region2_enabled))
        ]

    ]
 )
  subnet_restricted = flatten(
     [ for one_subnet in local.vpc_config.restricted.subnets:
         [ for one_region_id in keys(local.regions_config):
             merge({
               subnet_name   = "sb-${local.env_code}-${local.restricted_spoke_type}-${local.regions_config[one_region_id].name}${one_subnet.subnet_suffix}"
               subnet_ip     = one_subnet.ip_ranges[one_region_id]
               subnet_region = local.regions_config[one_region_id].name
               region_id     = one_region_id
               subnet_private_access = try(one_subnet.private_access,false)
               subnet_flow_logs      = try(one_subnet.flow_logs.enable,false)
               description                      = try(one_subnet.description, "First ${local.restricted_spoke_type} subnet example")
             },
             try(contains(keys(one_subnet),"service_projects") ?
               {
                 service_projects = one_subnet.service_projects
               } : null, null
             ),
             try(one_subnet.flow_logs.enable,false) ?
                 {
                   subnet_flow_logs_interval = try(one_subnet.flow_logs.interval,var.restricted_vpc_flow_logs.aggregation_interval)
                   subnet_flow_logs_metadata        = var.restricted_vpc_flow_logs.metadata
                   subnet_flow_logs_metadata_fields = var.restricted_vpc_flow_logs.metadata_fields
                   subnet_flow_logs_filter          = var.restricted_vpc_flow_logs.filter_expr
                 } : null,
               try(contains(keys(one_subnet),"role") ?
                 {
                   role = one_subnet.role
                 } : null,null
               ),
               try(contains(keys(one_subnet),"purpose") ?
                 {
                   purpose = one_subnet.purpose
                 } : null,null
               ),
               try(contains(keys(one_subnet),"secondary_ranges") ?
                 {
                   secondary_ranges = (
                   [ for one_range in one_subnet.secondary_ranges :
                     {
                       range_name = "rn-${local.env_code}-${local.restricted_spoke_type}-${local.regions_config[one_region_id].name}-${one_range.range_suffix}"
                       ip_cidr_range = try(one_range.ip_cidr_range[one_region_id],null)
                     } if contains(keys(one_range.ip_cidr_range),one_region_id) && ! try(local.regions_config[one_region_id].disabled,false)
                   ])
                 } : null, null  )
             )  if (try(!local.regions_config[one_region_id].disabled,true) && try(can(cidrhost(one_subnet.ip_ranges[one_region_id],1)),false)) &&
                   try(local.env_enabled,false) && try(local.vpc_config.restricted.enabled,false) &&
                   ((one_region_id == "region1" && local.region1_enabled) || (one_region_id == "region2" && local.region2_enabled))
         ]

     ]
  )
  filtered_base_subnets = [ for one_subnet in local.subnet_base :
    { for k,v in one_subnet: k=>v if (k != "secondary_ranges" && k != "region_id" && k != "service_projects")}
  ]
  filtered_restricted_subnets = [ for one_subnet in local.subnet_restricted :
    { for k,v in one_subnet: k=>v if (k != "secondary_ranges" && k != "region_id" && k != "service_projects") }
  ]
  filtered_base_subnets_names = [ for one_subnet in local.filtered_base_subnets : one_subnet.subnet_name]
  filtered_base_subnets_ips = [ for one_subnet in local.filtered_base_subnets : one_subnet.subnet_ip]
  filtered_restricted_subnets_names = [ for one_subnet in local.filtered_restricted_subnets : one_subnet.subnet_name]
  filtered_restricted_subnets_ips = [ for one_subnet in local.filtered_restricted_subnets : one_subnet.subnet_ip]

  secondary_base_subnets = {
    for one_subnet in local.subnet_base : one_subnet.subnet_name =>
      [
        for one_range in one_subnet.secondary_ranges : {
          range_name = one_range.range_name
          ip_cidr_range = one_range.ip_cidr_range
        }
      ] if contains(keys(one_subnet),"secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0,false)
  }
  secondary_restricted_subnets = {
    for one_subnet in local.subnet_restricted : one_subnet.subnet_name =>
      [
        for one_range in one_subnet.secondary_ranges : {
          range_name = one_range.range_name
          ip_cidr_range = one_range.ip_cidr_range
        }
      ] if contains(keys(one_subnet),"secondary_ranges") && try(length(one_subnet.secondary_ranges) > 0,false)
  }
  // MRo: reverse indexing by subnet name and region get the subnet symlinks
  // MRo: need to store in tfstate only the subnets enabled for sharing indexed by service project
  // base_subnets_self_links = [
  // "https://www.googleapis.com/compute/v1/projects/prj-p-shared-base-4qup/regions/northamerica-northeast1/subnetworks/sb-p-shared-base-northamerica-northeast1",
  // "https://www.googleapis.com/compute/v1/projects/prj-p-shared-base-4qup/regions/northamerica-northeast1/subnetworks/sb-p-shared-base-northamerica-northeast1-proxy",
  // ]
  sl_base_subnets_split = { for one_subnet_selflink in one(module.base_shared_vpc).subnets_self_links:
       one_subnet_selflink => {
        project_name = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "projects", ) + 1, )
        region_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "regions") + 1, )
        subnet_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "subnetworks") + 1, )
       }
  }
  sl_restricted_subnets_split = { for one_subnet_selflink in one(module.restricted_shared_vpc).subnets_self_links:
       one_subnet_selflink => {
        project_name = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "projects", ) + 1, )
        region_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "regions") + 1, )
        subnet_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "subnetworks") + 1, )
       }
  }

  sl_base_subnets_by_srvprj = {
    for one_subnet_selflink in one(module.base_shared_vpc).subnets_self_links:
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

  sl_restricted_subnets_by_srvprj = {
    for one_subnet_selflink in one(module.restricted_shared_vpc).subnets_self_links:
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
  }
  ***********/
  spoke_config        = module.vpc_config.spoke_config
  environment_code    = local.spoke_config.vpc_config.env_code
  mode                = local.spoke_config.vpc_config.mode

  default_region1     = local.spoke_config.regions.region1.default
  default_region2     = local.spoke_config.regions.region2.default
  region1_enabled     = local.spoke_config.regions.region1.enabled
  region2_enabled     = local.spoke_config.regions.region2.enabled

  subnet_base                     = local.spoke_config.base.subnets
  filtered_subnet_base            = local.spoke_config.base.filtered_subnets
  base_private_service_cidr       = local.spoke_config.base.private_service_cidr
  base_private_service_connect_ip = local.spoke_config.base.private_service_connect_ip
  base_vpc_routes                 = local.spoke_config.base.vpc_routes
  secondary_base_subnets          = local.spoke_config.base.secondary_ranges
  filtered_base_subnets_names     = local.spoke_config.base.filtered_subnets_names
  filtered_base_subnets_ips       = local.spoke_config.base.filtered_subnets_ips


  subnet_restricted                     = local.spoke_config.restricted.subnets
  filtered_subnet_restricted            = local.spoke_config.restricted.filtered_subnets
  restricted_private_service_cidr       = local.spoke_config.restricted.private_service_cidr
  restricted_private_service_connect_ip = local.spoke_config.restricted.private_service_connect_ip
  restricted_vpc_routes                 = local.spoke_config.restricted.vpc_routes
  secondary_restricted_subnets          = local.spoke_config.restricted.secondary_ranges
  filtered_restricted_subnets_names     = local.spoke_config.restricted.filtered_subnets_names
  filtered_restricted_subnets_ips       = local.spoke_config.restricted.filtered_subnets_ips


  nat_enabled         = local.spoke_config.nat_enabled
  router_ha_enabled   = local.spoke_config.router_ha_enabled

  base_subnet_self_links       = module.base_shared_vpc[0].subnets_self_links
  restricted_subnet_self_links = module.restricted_shared_vpc[0].subnets_self_links

  sl_base_subnets_split = { for one_subnet_selflink in local.base_subnet_self_links:
       one_subnet_selflink => {
        project_name = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "projects", ) + 1, )
        region_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "regions") + 1, )
        subnet_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "subnetworks") + 1, )
       }
  }
  sl_restricted_subnets_split = { for one_subnet_selflink in local.restricted_subnet_self_links:
       one_subnet_selflink => {
        project_name = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "projects", ) + 1, )
        region_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "regions") + 1, )
        subnet_name  = element(split("/", one_subnet_selflink), index(split("/", one_subnet_selflink), "subnetworks") + 1, )
       }
  }

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

  sl_restricted_subnets_by_srvprj = {
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
  }


}

module "vpc_config" {
  source = "../../modules/nhas_config/vpc_config"
  env  = var.env
  config_file = abspath("${path.module}/../../vpc_config.yaml")
}


/******************************************
 Restricted shared VPC
*****************************************/
module "restricted_shared_vpc" {
  source = "../restricted_shared_vpc"
  count  = length(local.subnet_restricted) > 0 ? 1 : 0
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

  depends_on = [module.restricted_shared_vpc]
}
