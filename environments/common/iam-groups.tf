/**
 * Copyright 2023 Google LLC
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


# https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/271
# the terraform service account must be added in admin.google.com as a groups admin
# https://admin.google.com/ac/roles/58150197607268354
# move to common
module "group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = var.iam-groups.id
  display_name = var.iam-groups.display_name
  description  = var.iam-groups.description
  domain       = var.iam-groups.domain
  #owners       = var.iam-groups.owners
  #managers     = var.iam-groups.managers
  members      = var.iam-groups.members
}

