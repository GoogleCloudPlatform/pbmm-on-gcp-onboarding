/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

prod_private_perimeter_firewall = {
  custom_rules = {
    allow-egress-internet = {
      description          = "Allow egress to the internet"
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = ["allow-egress-internet"]
      sources              = []
      rules = [
        {
          protocol = "tcp"
          ports    = []
        },
        {
          protocol = "udp"
          ports    = []
        }
      ]
      extra_attributes = {
        disabled           = false
        priority           = "1000"
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    allow-ssh-ingress = {
      description          = "Allow SSH Connections from the internet"
      direction            = "INGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = ["allow-ssh"]
      sources              = []
      rules = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      extra_attributes = {
        disabled  = false
        priority  = "1000"
        flow_logs = true
      }
    }
  }
}