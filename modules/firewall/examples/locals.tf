/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
  custom_rules = {
    // Example of custom tcp/udp rule
    deny-ingress-6534-6566 = {
      description          = "Deny all INGRESS to port 6534-6566"
      direction            = "INGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"] # source or destination ranges (depends on `direction`)
      use_service_accounts = false         # if `true` targets/sources expect list of instances SA, if false - list of tags
      targets              = null          # target_service_accounts or target_tags depends on `use_service_accounts` value
      sources              = null          # source_service_accounts or source_tags depends on `use_service_accounts` value
      rules = [{
        protocol = "tcp"
        ports    = ["6534-6566"]
        },
        {
          protocol = "udp"
          ports    = ["6534-6566"]
      }]

      extra_attributes = {
        disabled           = true
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }

    // Example how to allow connection from instances with `backend` tag, to instances with `databases` tag
    allow-backend-to-databases = {
      description          = "Allow backend nodes connection to databases instances"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = null
      use_service_accounts = false
      targets              = ["databases"] # target_tags
      sources              = ["backed"]    # source_tags
      rules = [{
        protocol = "tcp"
        ports    = ["3306", "5432", "1521", "1433"]
      }]

      extra_attributes = {}
    }

    // Example how to allow connection from an instance with a given service account
    allow-all-admin-sa = {
      description          = "Allow all traffic from admin sa instances"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = null
      use_service_accounts = true
      targets              = null
      sources              = ["admin@my-shiny-org.iam.gserviceaccount.com"]
      rules = [{
        protocol = "tcp"
        ports    = null # all ports
        },
        {
          protocol = "udp"
          ports    = null # all ports
        }
      ]
      extra_attributes = {
        priority  = 30
        flow_logs = true
      }
    }

    deny-egress = {
      description          = "Deny all Egress"
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"] # source or destination ranges (depends on `direction`)
      use_service_accounts = false         # if `true` targets/sources expect list of instances SA, if false - list of tags
      targets              = null          # target_service_accounts or target_tags depends on `use_service_accounts` value
      sources              = null          # source_service_accounts or source_tags depends on `use_service_accounts` value
      rules = [{
        protocol = "tcp"
        ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
      }]

      extra_attributes = {
        disabled           = true
        priority           = 65534
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    allow-egress-backend-to-databases = {
      description          = "Allow backend nodes connection to databases instances"
      direction            = "EGRESS"
      action               = "allow"
      ranges               = null
      use_service_accounts = false
      targets              = ["databases"] # target_tags
      sources              = ["backed"]    # source_tags
      rules = [{
        protocol = "tcp"
        ports    = ["3306", "5432", "1521", "1433"]
      }]

      extra_attributes = {}
    }
  }
}
