# Note: while the amount of outputs below might seem excessive,
# DO NOT DELETE THEM as many are necessary to add use-case templates
# in day1 (via remote state)
#

output "fgt-mgmt-eips" {
  value = module.fortigates.fgt_mgmt_eips
}

output "default_password" {
  value = module.fortigates.fgt_password
}

output "fgt_umigs" {
  value = module.fortigates.fgt_umigs
}

output "api-key" {
  value = module.fortigates.api_key
}

output "region" {
  value = var.GCE_REGION
}

output "prefix" {
  value = var.prefix
}

output "project" {
  value = var.GCP_PROJECT
}

output "ilb" {
  value = module.fortigates.ilb
}

output "health_check" {
  value = module.fortigates.health_check
}

output "internal_vpc" {
  value = module.fortigates.internal_vpc
}

output "internal_subnet" {
  value = module.fortigates.internal_subnet
}
