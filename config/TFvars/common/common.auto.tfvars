/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

org_policies = {
  directory_customer_id = ["<DIRECTORY_CUSTOMER_ID>"]
  policy_boolean        = { "constraints/compute.skipDefaultNetworkCreation" = false }
  policy_list           = {
    "constraints/gcp.resourceLocations" = {
      inherit_from_parent = null
      suggested_value     = "northamerica-northeast1"
      status              = false
      # The policies for location does not work with explicit deny rules,
      values = ["in:asia-locations", "in:australia-locations", "in:europe-locations", "in:us-locations", "in:southamerica-locations"]
    }
  }
  setDefaultPolicy      = false # leave false for testing
  vmAllowedWithExternalIp = [
    #projects/PROJECT_ID/zones/ZONE/instances/INSTANCE
  ]
  vmAllowedWithIpForward = [
    # projects/PROJECT_ID/zones/ZONE/instances/INSTANCE
  ]
}

folders = {
  parent = "organizations/<ORGID>"
  names  = ["Infrastructure", "Sandbox", "Workloads", "Audit and Security", "Automation", "Shared Services"] # Production, NonProduction and Platform are included in the module
  subfolders_1 = {
    SharedInfrastructure = "Infrastructure"
    Networking           = "Infrastructure"
    Prod                 = "Workloads"
    UAT                  = "Workloads"
    Dev                  = "Workloads"
    Audit                = "Audit and Security"
    Security             = "Audit and Security"
  }
  subfolders_2 = {
    ProdNetworking    = "Networking"
    NonProdNetworking = "Networking"
  }
}

access_context_manager = {
  policy_name         = ""
  policy_id           = "" # only used when previously existing
  user_defined_string = "acm<RAND>"
  access_level        = {
    basic = {
      description = "Access Level for USCA users"
      name        = "usca_access"
      regions     = ["US", "CA"]
    }
  } # leave empty for testing
}

audit = {
  user_defined_string            = "audit<RAND>" #must be globally unique
  additional_user_defined_string = "storage"
  billing_account                = "<BILLING_ACCOUNT>"
  audit_streams = {
    prod = {
      bucket_name          = "orgprodauditlogs<RAND>" # must be globally unique
      is_locked            = false
      bucket_force_destroy = true
      bucket_storage_class = "STANDARD"
      labels               = {
        <AUDIT_LABELS>
      }
      sink_name            = "org-audit-sink<RAND>" # must be unique across organization
      description          = "Org Sink"
      filter               = "severity >= WARNING"
      retention_period     = 1
      bucket_viewer        = "group:audit-viewers@<DOMAIN>"
    }
  }
  audit_lables = {}
}

audit_project_iam = [
  {
    member = "group:audit-admins@<DOMAIN>"
    #project = module.project.project_id  #(will be added during deployment using local var)
    roles = [
      "roles/viewer",
      "roles/editor",
    ]
  },
  {
    member = "group:audit-viewers@<DOMAIN>"
    roles = [
      "roles/viewer",
    ]
  }
]

/*
compute_network_users = [
  {
    members = [
      "group:group@test.domain.net",
      "user:user@google.com"
    ]
    #project = module.project.project_id
    subnetwork = "subnetworkname"
    region     = "northamerica-northeast1"
  }
]
*/

folder_iam = [
  {
    member = "group:workload-admins@<DOMAIN>"
    #folder = module.core-folders.folders_map_1_level["Workloads"].id #(will be added during deployment using local var)
    roles = [
      "roles/owner",
    ]
  },
]

organization_iam = [
  {
    member       = "group:organization-admins@<DOMAIN>"
    organization = "<ORGID>"
    roles = [
      "roles/owner",
    ]
  },
]

guardrails = {
  project_name    = "assets-validation<RAND>" #must be globally unique
  billing_account = "<BILLING_ACCOUNT>" #Billing Account in the format of ######-######-######
  org_id_scan_list = ["<ORGID>"]
  org_client          = false #Set to true if deploying remote landing zone.  Otherwise set to false if deploying for core landing zone.
  user_defined_string = "guardrail<RAND>"
}

custom_roles = {
  bq_admin = {
    title       = "Custom BQ Admin <RAND>"
    description = "BQ admin without data reading capabilities"
    role_id     = "custom_bq_admin<RAND>"
    permissions = [
      "bigquery.bireservations.get",
      "bigquery.bireservations.update",
      "bigquery.capacityCommitments.create",
      "bigquery.capacityCommitments.delete",
      "bigquery.capacityCommitments.get",
      "bigquery.capacityCommitments.list",
      "bigquery.capacityCommitments.update",
      "bigquery.config.get",
      "bigquery.config.update",
      "bigquery.connections.create",
      "bigquery.connections.delete",
      "bigquery.connections.get",
      "bigquery.connections.getIamPolicy",
      "bigquery.connections.list",
      "bigquery.connections.setIamPolicy",
      "bigquery.connections.update",
      "bigquery.connections.use",
      "bigquery.datasets.create",
      "bigquery.datasets.delete",
      "bigquery.datasets.get",
      "bigquery.datasets.getIamPolicy",
      "bigquery.datasets.setIamPolicy",
      "bigquery.datasets.update",
      "bigquery.datasets.updateTag",
      "bigquery.jobs.create",
      "bigquery.jobs.get",
      "bigquery.jobs.list",
      "bigquery.jobs.listAll",
      "bigquery.jobs.update",
      "bigquery.models.create",
      "bigquery.models.delete",
      "bigquery.models.export",
      "bigquery.models.getMetadata",
      "bigquery.models.list",
      "bigquery.models.updateMetadata",
      "bigquery.models.updateTag",
      "bigquery.readsessions.create",
      "bigquery.readsessions.update",
      "bigquery.reservationAssignments.create",
      "bigquery.reservationAssignments.delete",
      "bigquery.reservationAssignments.list",
      "bigquery.reservationAssignments.search",
      "bigquery.reservations.create",
      "bigquery.reservations.delete",
      "bigquery.reservations.get",
      "bigquery.reservations.list",
      "bigquery.reservations.update",
      "bigquery.routines.create",
      "bigquery.routines.delete",
      "bigquery.routines.get",
      "bigquery.routines.list",
      "bigquery.routines.update",
      "bigquery.savedqueries.create",
      "bigquery.savedqueries.delete",
      "bigquery.savedqueries.get",
      "bigquery.savedqueries.list",
      "bigquery.savedqueries.update",
      "bigquery.tables.create",
      "bigquery.tables.delete",
      "bigquery.tables.export",
      "bigquery.tables.get",
      "bigquery.tables.getIamPolicy",
      "bigquery.tables.list",
      "bigquery.tables.setCategory",
      "bigquery.tables.setIamPolicy",
      "bigquery.tables.update",
      "bigquery.tables.updateTag",
      "bigquery.transfers.get",
      "bigquery.transfers.update",
      "resourcemanager.projects.get",
      "resourcemanager.projects.list",
      ]
    }
  bq_viewer = {
    title       = "Custom BQ Viewer <RAND>"
    description = "BQ Viewer without data reading capabilities"
    role_id     = "custom_bq_viewer<RAND>"
    permissions = [
      "bigquery.bireservations.get",
      "bigquery.capacityCommitments.get",
      "bigquery.capacityCommitments.list",
      "bigquery.config.get",
      "bigquery.connections.get",
      "bigquery.connections.list",
      "bigquery.datasets.get",
      "bigquery.jobs.get",
      "bigquery.jobs.list",
      "bigquery.jobs.listAll",
      "bigquery.models.getMetadata",
      "bigquery.models.list",
      "bigquery.reservationAssignments.list",
      "bigquery.reservations.get",
      "bigquery.reservations.list",
      "bigquery.routines.get",
      "bigquery.routines.list",
      "bigquery.savedqueries.get",
      "bigquery.savedqueries.list",
      "bigquery.tables.get",
      "bigquery.tables.list",
      "bigquery.transfers.get",
      "resourcemanager.projects.get",
      "resourcemanager.projects.list",
    ]
  }
}