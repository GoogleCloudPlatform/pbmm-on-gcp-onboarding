/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_firewall = {
  custom_rules = {
    allow-egress-internet = {
      description          = "Allow egress to the internet"
      direction            = "EGRESS"
      action               = "allow"
      ranges               = ["10.108.1.0/25"]
      use_service_accounts = false
      targets              = ["allow-egress-internet"]
      sources              = []
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        disabled           = true
        priority           = 1001
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    },
    allow-web-to-midtier = {
      description          = "Allow web app to interact with business logic instance"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = []
      use_service_accounts = false
      targets              = ["app"]
      sources              = ["web"]
      rules = [
        {
          protocol = "tcp"
          ports    = ["80"]
        },
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
      extra_attributes = {
        disabled  = false
        priority  = 90
        flow_logs = true
      }
    },
    allow-midtier-to-datatier = {
      description          = "Allow business logic instance to interact with data tier"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = []
      use_service_accounts = false
      targets              = ["data"]
      sources              = ["web"]
      rules = [
        {
          protocol = "tcp"
          ports    = ["80"]
        },
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
      extra_attributes = {
        disabled  = false
        priority  = 90
        flow_logs = true
      }
    },
    deny-datatier-to-any = {
      description          = "Deny data tier instance to interact with other instances"
      direction            = "EGRESS"
      action               = "deny"
      ranges               = []
      use_service_accounts = false
      targets              = ["data"]
      sources              = []
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        disabled  = false
        priority  = 110
        flow_logs = true
      }
    },
    deny-webtier-to-datatier = {
      description          = "Deny web tier instance to interact with data tier instance"
      direction            = "INGRESS"
      action               = "deny"
      ranges               = []
      use_service_accounts = false
      targets              = ["data"]
      sources              = ["web"]
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        disabled  = false
        priority  = 120
        flow_logs = true
      }
    }
  }
}