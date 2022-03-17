/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

organization_config = {
  org_id          = "<ORGID>" # Numeric portion only '#############'
  default_region  = "northamerica-northeast1" #Cloudbuild Region
  department_code = "<DEPARTMENT_CODE>" # Two characters, one capital and one lowercase (e.g. 'It').
  owner           = "<OWNER>" # Used in naming standard
  environment     = "<ENVIRONMENT>" # SBOX / NPD / UAT / PRD
  location        = "northamerica-northeast1" #Location used for resources. Currently northamerica-northeast1 is available
  labels          = {
    <ORGANIZATION_LABELS>
  } #Object used for resource labels
  root_node       = "organizations/<ORGID>"
  contacts = {
    <CONTACTS> # Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
  }
  billing_account = "<BILLING_ACCOUNT>" # Format of ######-######-######
}
