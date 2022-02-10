/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Base Superset of Permissions curated from the following roles:
# Billing Account Administrator (roles/billing.admin)
# Billing Account Costs Manager (roles/billing.costsManager)
# Billing Account Creator (roles/billing.creator)
# Billing Account Usage Commitment Recommender Admin (roles/recommender.billingAccountCudAdmin)

# NOTE:  IAM Recommender should be used to filter these down in the future
locals {
  billing_administrator_role = {
    billing_administrator = {
      title       = "Billing Administrator"
      description = "Billing Administrator"
      role_id     = "billing_administrator"
      permissions = [
        "billing.accounts.close",
        "billing.accounts.create",
        "billing.accounts.get",
        "billing.accounts.getIamPolicy",
        "billing.accounts.getPaymentInfo",
        "billing.accounts.getPricing",
        "billing.accounts.getSpendingInformation",
        "billing.accounts.getUsageExportSpec",
        "billing.accounts.list",
        "billing.accounts.move",
        "billing.accounts.redeemPromotion",
        "billing.accounts.removeFromOrganization",
        "billing.accounts.reopen",
        "billing.accounts.setIamPolicy",
        "billing.accounts.update",
        "billing.accounts.updatePaymentInfo",
        "billing.accounts.updateUsageExportSpec",
        "billing.budgets.create",
        "billing.budgets.delete",
        "billing.budgets.get",
        "billing.budgets.list",
        "billing.budgets.update",
        "billing.credits.list",
        "billing.resourceAssociations.create",
        "billing.resourceAssociations.delete",
        "billing.resourceAssociations.list",
        "billing.subscriptions.create",
        "billing.subscriptions.get",
        "billing.subscriptions.list",
        "billing.subscriptions.update",
        "cloudnotifications.activities.list",
        "commerceoffercatalog.offers.get",
        "consumerprocurement.accounts.create",
        "consumerprocurement.accounts.delete",
        "consumerprocurement.accounts.get",
        "consumerprocurement.accounts.list",
        "consumerprocurement.orders.cancel",
        "consumerprocurement.orders.get",
        "consumerprocurement.orders.list",
        "consumerprocurement.orders.modify",
        "consumerprocurement.orders.place",
        "dataprocessing.datasources.get",
        "dataprocessing.datasources.list",
        "dataprocessing.groupcontrols.get",
        "dataprocessing.groupcontrols.list",
        "logging.logEntries.list",
        "logging.logServiceIndexes.list",
        "logging.logServices.list",
        "logging.logs.list",
        "logging.privateLogEntries.list",
        "recommender.commitmentUtilizationInsights.get",
        "recommender.commitmentUtilizationInsights.list",
        "recommender.commitmentUtilizationInsights.update",
        "recommender.usageCommitmentRecommendations.get",
        "recommender.usageCommitmentRecommendations.list",
        "recommender.usageCommitmentRecommendations.update",
        "resourcemanager.organizations.get",
        "resourcemanager.projects.createBillingAssignment",
        "resourcemanager.projects.deleteBillingAssignment"
      ]
    }
  }
}