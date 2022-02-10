/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "custom_ingress_allow_rules" {
  description = "Custom ingress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "INGRESS" && length(rule.allow) > 0
  ]
}

output "custom_ingress_deny_rules" {
  description = "Custom ingress rules with deny blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "INGRESS" && length(rule.deny) > 0
  ]
}

output "custom_egress_allow_rules" {
  description = "Custom egress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "EGRESS" && length(rule.allow) > 0
  ]
}

output "custom_egress_deny_rules" {
  description = "Custom egress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "EGRESS" && length(rule.deny) > 0
  ]
}