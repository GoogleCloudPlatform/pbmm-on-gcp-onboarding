/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

bootstrap = {
  userDefinedString           = "<USER_DEFINED_STRING><RAND>" # Required. Appended to project name/id
  additionalUserDefinedString = "<ADDITIONAL_USER_DEFINED_STRING>"
  billingAccount              = "<BILLING_ACCOUNT>" # Billing Account ID in the format of ######-######-######
  parent                      = "organizations/<ORGID>" # Organization Node in format "organizations/#############"
  terraformDeploymentAccount  = "tfdeployer" #Name of the service account used to deploy the terraform code
  bootstrapEmail              = "user:<BOOTSTRAP_EMAIL>" # In the form of "user:user@email.com"
  region                      = "northamerica-northeast1" #Region name. northamerica-northeast1
  cloud_source_repo_name      = "<CLOUD_SOURCE_REPO_NAME><RAND>"
  projectServices = [
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "sourcerepo.googleapis.com",
    "appengine.googleapis.com"
  ]
  tfstate_buckets = {
    common = {
      name = "common<RAND>" 
      labels = {
      }
      storage_class = "STANDARD"
      force_destroy = true
    },
    nonprod = {
      name = "nonprod<RAND>"
      labels = {
      }
      force_destroy = true
      storage_class = "STANDARD"
    },
    prod = {
      name = "prod<RAND>"
      labels = {
      }
      force_destroy = true
      storage_class = "STANDARD"
    }
  }
}


# Cloud Build
cloud_build_admins = [
  "group:cloudbuild-admins@<DOMAIN>",
]
group_build_viewers = [
  "group:cloudbuild-viewers@<DOMAIN>",
]

#cloud_build_user_defined_string = ""

cloud_build_config = { #Defines the triggers for the different environments in cloud build
  landing-zone-bootstrap = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/bootstrap",
    included_files = [
      "environments/bootstrap/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = true,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
  landing-zone-nonprod = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/nonprod",
    included_files = [
      "environments/nonprod/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = true,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
  landing-zone-prod = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/prod",
    included_files = [
      "environments/prod/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = true,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
}

/*
sa_impersonation_admin = ""


sa_impersonation_grants= [
    {
      member  = "group:name@name.canada.ca"
      project = module.project.project_id
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    }
]


sa_create_assign = [
    {
      account_id   = "test-account"
      display_name = "test1 display"
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    },
    {
      account_id   = "another-test"
      display_name = "Another Test"
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    }
  ]

*/
