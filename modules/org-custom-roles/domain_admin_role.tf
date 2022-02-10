/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
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