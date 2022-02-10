/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Base Superset of Permissions curated from the following roles:
# Billing Account Costs Manager (roles/billing.costsManager)
# Billing Account User (roles/billing.user)

# NOTE:  IAM Recommender should be used to filter these down in the future
locals {
  billing_operations_role = {
    billing_operations = {
      title       = "Billing Operations"
      description = "Billing Operations"
      role_id     = "billing_operations"
      permissions = [
        "billing.accounts.get",
        "billing.accounts.getIamPolicy",
        "billing.accounts.getSpendingInformation",
        "billing.accounts.getUsageExportSpec",
        "billing.accounts.list",
        "billing.accounts.redeemPromotion",
        "billing.accounts.updateUsageExportSpec",
        "billing.budgets.create",
        "billing.budgets.delete",
        "billing.budgets.get",
        "billing.budgets.list",
        "billing.budgets.update",
        "billing.credits.list",
        "billing.resourceAssociations.create",
        "billing.resourceAssociations.list"
      ]
    }
  }
}