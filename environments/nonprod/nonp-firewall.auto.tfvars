/**
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/ 
//nonprod_firewall = {
nonprod_firewall = {
  custom_rules = {
      allow-egress-internet = {
        description          = "Allow egress to the internet"
        direction            = "EGRESS"
        action               = "allow"
        ranges               = ["10.108.128.0/24"]
        use_service_accounts = false
        targets              = ["allow-egress-internet"]
        sources              = [] #""]
        rules = [
          {
            protocol = "all"#"tcp"
            ports    = []
          }#,
          #{
          #  protocol = "udp"
          #  ports    = []
          #}
        ]
        extra_attributes = {
          disabled           = true #false
          priority           = 1001 #"1000"
          flow_logs          = true
          flow_logs_metadata = "EXCLUDE_ALL_METADATA"
        }
      }
      allow-web-to-midtier = {
      #allow-ssh-ingress = {
        description          = "Allow the web app to interact with the business logic instance"
        direction            = "INGRESS"
        action               = "allow"
        ranges               = []#"10.108.128.0/24"]
        use_service_accounts = false
        targets              = ["app"]#"allow-ssh"]
        sources              = ["web"]#[] #""]
        rules = [
          {
            protocol = "tcp"
            ports    = ["80"]#"22"]
          },
          {
            protocol = "tcp"
            ports    = ["443"]
          }
        ]
        extra_attributes = {
          disabled  = false
          priority  = 90 #"1000"
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
        sources              = ["app"]
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
          priority  = 100
          flow_logs = true
        }
      }
    },
    deny-datatier-to-any = {
        description          = "Deny data tier instance to interact with other instances"
        direction            = "EGRESS"
        action               = "deny"
        ranges               = ["10.108.128.0/24"]
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
    },
    allow-ingress-to-webtier = {
        description          = "Allow http ingress to web tier instances with web network tag"
        direction            = "INGRESS"
        action               = "allow"
        ranges               = ["10.108.0.0/16"]
        use_service_accounts = false
        targets              = ["web"]
        sources              = []
        rules = [
          {
            protocol = "tcp"
            ports    = ["80","443"]
          }
        ]
        extra_attributes = {
          disabled  = false
          priority  = 120
          flow_logs = true
        }
    },
    allow-apptier-egress-to-databse = {
        description          = "Allow tcp egress to access sql and postgres database"
        direction            = "EGRESS"
        action               = "allow"
        ranges               = ["10.0.0.0/8"]
        use_service_accounts = false
        targets              = ["app", "data"]
        sources              = []
        rules = [
          {
            protocol = "tcp"
            ports    = ["3306","5432"]
          }
        ]
        extra_attributes = {
          disabled  = false
          priority  = 120
          flow_logs = true
        }
    },
    allow-webtier-egress-to-databse = {
        description          = "Deny tcp egress to access sql and postgres database"
        direction            = "EGRESS"
        action               = "deny"
        ranges               = ["10.0.0.0/8"]
        use_service_accounts = false
        targets              = ["web"]
        sources              = []
        rules = [
          {
            protocol = "tcp"
            ports    = ["3306","5432"]
          }
        ]
        extra_attributes = {
          disabled  = false
          priority  = 120
          flow_logs = true
        }
    },
    allow-web-to-app-egress = {
        description          = "Allow webapps to access middletier subnet over http/s"
        direction            = "EGRESS"
        action               = "allow"
        ranges               = ["10.108.131.0/24"]
        use_service_accounts = false
        targets              = ["web"]
        sources              = []
        rules = [
          {
            protocol = "tcp"
            ports    = ["80","443"]
          }
        ]
        extra_attributes = {
          disabled  = false
          priority  = 100
          flow_logs = true
        }
    },
    allow-all-to-web-egress = {
        description          = "Allow all to reach apps in frontend subnet over http/s"
        direction            = "EGRESS"
        action               = "allow"
        ranges               = ["10.108.130.0/24"]
        use_service_accounts = false
        targets              = []
        sources              = []
        rules = [
          {
            protocol = "tcp"
            ports    = ["80","443"]
          }
        ]
        extra_attributes = {
          disabled  = false
          priority  = 100
          flow_logs = true
        }
    }            
}