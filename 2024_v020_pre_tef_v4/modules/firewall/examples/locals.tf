/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



locals {
  custom_rules = {
    // Example of custom tcp/udp rule
    deny-ingress-6534-6566 = {
      description          = "Deny all INGRESS to port 6534-6566"
      direction            = "INGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/1", "128.0.0.0/1"] # source or destination ranges (depends on `direction`)
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
      ranges               = ["0.0.0.0/1", "128.0.0.0/1"] # source or destination ranges (depends on `direction`)
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
