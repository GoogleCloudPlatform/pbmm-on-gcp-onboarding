/*********
 * Copyleft none
 ********/

output "bu_config" {
   description  = "sl_basspoke_confige_subnets_split"
   value        = local.bu_config
}

output "sl_base_subnets_by_srvprj" {
   description = "sl_base_subnets_by_srvprj"
   value = local.sl_base_subnets_by_srvprj
}

output "sl_restricted_subnets_by_srvprj" {
   description = "sl_restricted_subnets_by_srvprj"
   value = local.sl_restricted_subnets_by_srvprj
}

output "billing_account" {
   description = "billing_account"
   value = local.billing_account
}