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