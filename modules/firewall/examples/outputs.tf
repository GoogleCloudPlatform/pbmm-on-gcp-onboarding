/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "custom_ingress_allow_rules" {
  description = "Custom ingress rules with allow blocks."
  value       = module.firewall.custom_ingress_allow_rules
}

output "custom_ingress_deny_rules" {
  description = "Custom ingress rules with deny blocks."
  value       = module.firewall.custom_ingress_deny_rules
}

output "custom_egress_allow_rules" {
  description = "Custom egress rules with allow blocks."
  value       = module.firewall.custom_egress_allow_rules
}

output "custom_egress_deny_rules" {
  description = "Custom egress rules with allow blocks."
  value       = module.firewall.custom_egress_deny_rules
}