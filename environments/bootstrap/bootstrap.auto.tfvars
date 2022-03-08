/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# This bootstrap script is meant to be run by one elevated user, in one sitting, with the permanent naming convention to be used. 
# CAVEATS - The reason for this is: 
# Permissions for that user are temporary, changing users before the automation takes over operations locks other users out of this process
# Accomplishing this is one sitting allows all users to contribute to repairing any issues in the environment by contributing code
# Project_Ids are globally consistent across all of Google Cloud Platform, projects take 7 days to delete and wont release that unique name until fully deleted. 
#

bootstrap = {
  userDefinedString           = "bootstrap" # REQUIRED EDIT Appended to project name/id
  additionalUserDefinedString = "" # OPTIONAL EDIT Additional appended string
  billingAccount              = "####" # REQUIRED EDIT Billing Account in the format of ######-######-######
  parent                      = "folders/####" # REQUIRED EDIT Organization Node in format "organizations/#############" or "folders/#############"
  terraformDeploymentAccount  = "tf-svc-acc" # REQUIRED EDIT Name of the service account used to de ploy the terraform code
  bootstrapEmail              = "user:@" # REQUIRED EDIT In the form of 'user:user@email.com
  region                      = "northamerica-northeast1" # REQUIRED EDIT Region name. northamerica-northeast1
  cloud_source_repo_name      = "lzrepo" # REQUIRED EDIT CSR used as a mirror for code
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
      name = "commonstate" # REQUIRED EDIT Must be globally unique
      labels = {
      }
      storage_class = "STANDARD"
      force_destroy = true
    },
    nonprod = {
      name = "nonprodstate" # REQUIRED EDIT Must be globally unique
      labels = {
      }
      force_destroy = true
      storage_class = "STANDARD"
    },
    prod = {
      name = "prodstate" # REQUIRED EDIT Must be globally unique
      labels = {
      }
      force_destroy = true
      storage_class = "STANDARD"
    }
  }
}
# Cloud Build
cloud_build_admins = [
  "user:user@google.com", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
]
group_build_viewers = [
  "user:user@google.com", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
]

#cloud_build_user_defined_string = ""



cloud_build_config = { # OPTIONAL EDIT Defines the triggers for the different environments in cloud build
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
  landing-zone-common = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/common",
    included_files = [
      "environments/common/**",
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