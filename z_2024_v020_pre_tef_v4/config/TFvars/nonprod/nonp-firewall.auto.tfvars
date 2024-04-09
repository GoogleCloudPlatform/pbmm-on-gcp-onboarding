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



nonprod_firewall = {
  custom_rules = { # REQUIRED EDIT One or more objects required
      allow-egress-internet = { # Name of the rule
        description          = "Allow egress to the internet"
        direction            = "EGRESS"
        action               = "allow"
        ranges               = ["0.0.0.0/1", "128.0.0.0/1"]
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
          priority           = 1000
          flow_logs          = true
          flow_logs_metadata = "EXCLUDE_ALL_METADATA"
        }
      }
      allow-ssh-ingress = {
        description          = "Allow SSH Connections from the internet"
        direction            = "INGRESS"
        action               = "allow"
        ranges               = ["0.0.0.0/1", "128.0.0.0/1"]
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
          priority  = 1000
          flow_logs = true
        }
      }
    }
}