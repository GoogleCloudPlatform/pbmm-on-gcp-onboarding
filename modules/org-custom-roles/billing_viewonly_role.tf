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