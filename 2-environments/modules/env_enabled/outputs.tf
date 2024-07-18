/*********
 * Copyleft none
 ********/

output "restricted_enabled" {
  description = "True if deployment of restricted environments enabled"
  value = local.restricted_enabled
}

output "management_enabled" {
  description = "True if deployment of management environments enabled"
  value = local.management_enabled
}

output "identity_enabled" {
  description = "True if deployment of identity environments enabled"
  value = local.identity_enabled
}