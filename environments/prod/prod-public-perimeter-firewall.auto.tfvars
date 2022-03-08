/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_public_perimeter_firewall = {
  custom_rules = {
    allow-egress-internet = {
      description          = "Allow egress to the internet"
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = []
      sources              = []
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        disabled           = true
        priority           = "1001"
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    allow-ingress-internet = {
      description          = "Allow ingress from the internet"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = []
      sources              = []
      rules = [
        {
          protocol = "all"
          ports    = []
        }
      ]
      extra_attributes = {
        disabled  = true
        priority  = "1001"
        flow_logs = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
  }
}