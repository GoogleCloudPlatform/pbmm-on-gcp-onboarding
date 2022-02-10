/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

# Base Superset of Permissions curated from the following roles:
# Billing Account Viewer (roles/billing.viewer)
# Billing Account Usage Commitment Recommender Viewer (roles/recommender.billingAccountCudViewer)

# NOTE:  IAM Recommender should be used to filter these down in the future
locals {
  billing_viewonly_role = {
    billing_viewonly = {
      title       = "Billing ViewOnly"
      description = "Billing ViewOnly"
      role_id     = "billing_viewonly"
      permissions = [
        "billing.accounts.get",
        "billing.accounts.getIamPolicy",
        "billing.accounts.getPaymentInfo",
        "billing.accounts.getPricing",
        "billing.accounts.getSpendingInformation",
        "billing.accounts.getUsageExportSpec",
        "billing.accounts.list",
        "billing.budgets.get",
        "billing.budgets.list",
        "billing.credits.list",
        "billing.resourceAssociations.list",
        "billing.subscriptions.get",
        "billing.subscriptions.list",
        "commerceoffercatalog.offers.get",
        "consumerprocurement.accounts.get",
        "consumerprocurement.accounts.list",
        "consumerprocurement.orders.get",
        "consumerprocurement.orders.list",
        "dataprocessing.datasources.get",
        "dataprocessing.datasources.list",
        "dataprocessing.groupcontrols.get",
        "dataprocessing.groupcontrols.list",
        "recommender.commitmentUtilizationInsights.get",
        "recommender.commitmentUtilizationInsights.list",
        "recommender.usageCommitmentRecommendations.get",
        "recommender.usageCommitmentRecommendations.list"
      ]
    }
  }
}