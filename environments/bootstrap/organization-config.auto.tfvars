/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

organization_config = {
  org_id          = "REPLACE_ORGANIZATION_ID" # REQUIRED EDIT Numeric portion only '#############'"
  default_region  = "northamerica-northeast1" # REQUIRED EDIT Cloudbuild Region
  department_code = "Os" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
  owner           = "obs" # REQUIRED EDIT Used in naming standard
  environment     = "P" # REQUIRED EDIT S-Sandbox P-Production Q-Quality D-development
  location        = "northamerica-northeast1" # REQUIRED EDIT Location used for resources. Currently northamerica-northeast1 is available
  labels          = {} # not REQUIRED EDIT Object used for resource labels
  root_node       = "folders/REPLACE_FOLDER_ID" # REQUIRED EDIT Organization Node in format "organizations/#############"
  contacts = {
    "admin-super@gcp.obrien.services" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
  }
  billing_account = "REPLACE_BILLING_ID" # REQUIRED EDIT Format of ######-######-###### 
}

