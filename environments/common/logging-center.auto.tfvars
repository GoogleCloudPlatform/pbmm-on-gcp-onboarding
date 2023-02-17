/**
 * Copyright 2023 Google LLC
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

logging_centers = {
  organization-logging-center = {
    user_defined_string            = "REPLACE_LOGGING_ORG_PROJECT_USD"                        # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
    additional_user_defined_string = ""                        # OPTIONAL EDIT Additional appended string
    billing_account                = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
    projectlabels = {
      creator     = ""
      environment = "all"
    }
    central_log_bucket = {
      name           = "REPLACE_LOGGING_ORG_BUCKET" # REQUIRED EDIT must contribute to being unique in this project. Name pattern: <env>-<log_type>-logs
      description    = "A central logs bucket for audit logs from all projects in organization"
      location       = "northamerica-northeast1"
      retention_days = "7"
      source_organization_sink = {
        organization_id  = ""
        include_children = true
        inclusion_filter = <<-EOT
        LOG_ID("cloudaudit.googleapis.com/activity") OR 
        LOG_ID("externalaudit.googleapis.com/activity") OR 
        LOG_ID("cloudaudit.googleapis.com/system_event") OR 
        LOG_ID("externalaudit.googleapis.com/system_event") OR 
        LOG_ID("cloudaudit.googleapis.com/access_transparency") OR 
        LOG_ID("externalaudit.googleapis.com/access_transparency")
        EOT
        disabled         = false
      }
      exporting_project_sink = {
        destination_bucket          = "REPLACE_LOGGING_ORG_DEST_BUCKET" # REQUIRED EDIT must contribute to being globally unique
        destination_bucket_location = "northamerica-northeast1"
        destination_project         = ""
        retention_period            = 1
        unique_writer_identity      = true
        inclusion_filter            = <<-EOT
        LOG_ID("cloudaudit.googleapis.com/activity") OR 
        LOG_ID("externalaudit.googleapis.com/activity") OR 
        LOG_ID("cloudaudit.googleapis.com/system_event") OR 
        LOG_ID("externalaudit.googleapis.com/system_event") OR 
        LOG_ID("cloudaudit.googleapis.com/access_transparency") OR 
        LOG_ID("externalaudit.googleapis.com/access_transparency")
        EOT
        disabled                    = false
      }
    }
    logging_center_viewers = ["REPLACE_CLOUD_BUILD_ADMINS"] # REQUIRED EDIT. 
  }

  dev-logging-center = {
    user_defined_string            = "REPLACE_LOGGING_DEV_PROJECT_USD"                        # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
    additional_user_defined_string = ""                        # OPTIONAL EDIT Additional appended string
    billing_account                = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
    projectlabels = {
      creator     = ""
      environment = "dev"
    }
    central_log_bucket = {
      name           = "REPLACE_LOGGING_DEV_BUCKET" # REQUIRED EDIT must contribute to being unique in this project. Name pattern: <env>-<log_type>-logs
      description    = "A central logs bucket for all logs from dev projects"
      location       = "northamerica-northeast1"
      retention_days = "7"
      source_folder_sink = {
        folder           = ""
        include_children = true
        inclusion_filter = ""
        disabled         = false
      }
      exporting_project_sink = {
        destination_bucket          = "REPLACE_LOGGING_DEV_DEST_BUCKET" # REQUIRED EDIT must contribute to being globally unique
        destination_bucket_location = "northamerica-northeast1"
        destination_project         = ""
        retention_period            = 1
        unique_writer_identity      = true
        inclusion_filter            = ""
        disabled                    = false
      }
    }
    logging_center_viewers = ["REPLACE_CLOUD_BUILD_ADMINS"] # REQUIRED EDIT. 
  }

  uat-logging-center = {
    user_defined_string            = "REPLACE_LOGGING_UAT_USD"                        # REQUIRED EDIT must contribute to being globally unique
    additional_user_defined_string = ""                        # OPTIONAL EDIT check 61 char aggregate limit
    billing_account                = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
    projectlabels = {
      creator     = ""
      environment = "uat"
    }
    central_log_bucket = {
      name           = "REPLACE_LOGGING_UAT_BUCKET" # REQUIRED EDIT must contribute to being unique in this project. Name pattern: <env>-<log_type>-logs
      description    = "A central logs bucket for all uat projects"
      location       = "northamerica-northeast1"
      retention_days = "7"
      source_folder_sink = {
        folder           = ""
        include_children = true
        inclusion_filter = ""
        disabled         = false
      }
      exporting_project_sink = {
        destination_bucket          = "REPLACE_LOGGING_UAT_DEST_BUCKET" # REQUIRED EDIT must contribute to being globally unique
        destination_bucket_location = "northamerica-northeast1"
        destination_project         = ""
        retention_period            = 1
        unique_writer_identity      = true
        inclusion_filter            = ""
        disabled                    = false
      }
    }
    logging_center_viewers = ["REPLACE_CLOUD_BUILD_ADMINS"] # REQUIRED EDIT. 
  }

  prod-logging-center = {
    user_defined_string            = "REPLACE_LOGGING_PROD_USD"                        # REQUIRED EDIT must contribute to being globally unique
    additional_user_defined_string = ""                        # OPTIONAL EDIT check 61 char aggregate limit
    billing_account                = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
    projectlabels = {
      creator     = ""
      environment = "prod"
    }
    central_log_bucket = {
      name           = "REPLACE_LOGGING_PROD_BUCKET" # REQUIRED EDIT must contribute to being unique in this project. Name pattern: <env>-<log_type>-logs
      description    = "A central logs bucket for all prod projects"
      location       = "northamerica-northeast1"
      retention_days = "7"
      source_folder_sink = {
        folder           = ""
        include_children = true
        inclusion_filter = ""
        disabled         = false
      }
      exporting_project_sink = {
        destination_bucket          = "REPLACE_LOGGING_PROD_DEST_BUCKET" # REQUIRED EDIT must contribute to being globally unique
        destination_bucket_location = "northamerica-northeast1"
        destination_project         = ""
        retention_period            = 1
        unique_writer_identity      = true
        inclusion_filter            = ""
        disabled                    = false
      }
    }
    logging_center_viewers = ["REPLACE_CLOUD_BUILD_ADMINS"] # REQUIRED EDIT. 
  }
}
