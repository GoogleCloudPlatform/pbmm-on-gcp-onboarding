/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

organization_config = {
  org_id          = "" # REQUIRED EDIT Numeric portion only '#############'"
  default_region  = "" # REQUIRED EDIT Cloudbuild Region
  department_code = "" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
  owner           = "" # REQUIRED EDIT Used in naming standard
  environment     = "" # REQUIRED EDIT S-Sandbox P-Production Q-Quality D-development
  location        = "" # REQUIRED EDIT Location used for resources. Currently northamerica-northeast1 is available
  labels          = {} # REQUIRED EDIT Object used for resource labels
  root_node       = "" # REQUIRED EDIT Organization Node in format "organizations/#############"
  contacts = {
    "user@email.com" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
  }
  billing_account = "" # REQUIRED EDIT Format of ######-######-######
}

