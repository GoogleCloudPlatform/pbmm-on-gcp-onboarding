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



# Base Superset of Permissions curated from the following roles:
# DNS Administrator - Create modify and delete DNS resources
# Cloud Domains Admin - Administer Domains

# NOTE:  IAM Recommender should be used to filter these down in the future
locals {
  domain_administrator_role = {
    domain_administrator = {
      title       = "Domain Administrator"
      description = "Domain Administrator"
      role_id     = "domain_administrator"
      permissions = [
        "dns.changes.create",
        "dns.changes.get",
        "dns.changes.list",
        "dns.dnsKeys.get",
        "dns.dnsKeys.list",
        "dns.managedZoneOperations.get",
        "dns.managedZoneOperations.list",
        "dns.managedZones.create",
        "dns.managedZones.delete",
        "dns.managedZones.get",
        "dns.managedZones.list",
        "dns.managedZones.update",
        "dns.networks.bindDNSResponsePolicy",
        "dns.networks.bindPrivateDNSPolicy",
        "dns.networks.bindPrivateDNSZone",
        "dns.networks.targetWithPeeringZone",
        "dns.policies.create",
        "dns.policies.delete",
        "dns.policies.get",
        "dns.policies.getIamPolicy",
        "dns.policies.list",
        "dns.policies.setIamPolicy",
        "dns.policies.update",
        "dns.projects.get",
        "dns.resourceRecordSets.create",
        "dns.resourceRecordSets.delete",
        "dns.resourceRecordSets.get",
        "dns.resourceRecordSets.list",
        "dns.resourceRecordSets.update",
        "dns.responsePolicies.create",
        "dns.responsePolicies.delete",
        "dns.responsePolicies.get",
        "dns.responsePolicies.list",
        "dns.responsePolicies.update",
        "dns.responsePolicyRules.create",
        "dns.responsePolicyRules.delete",
        "dns.responsePolicyRules.get",
        "dns.responsePolicyRules.list",
        "dns.responsePolicyRules.update",
        "domains.locations.get",
        "domains.locations.list",
        "domains.operations.cancel",
        "domains.operations.get",
        "domains.operations.list",
        "resourcemanager.projects.get",
        "resourcemanager.projects.list"
      ]
    }
  }
}