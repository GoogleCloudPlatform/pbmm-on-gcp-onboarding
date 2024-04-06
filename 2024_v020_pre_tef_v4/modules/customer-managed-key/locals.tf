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

locals {
  kms_supported_serviceagents = {
    "cloudkms.googleapis.com"      = "serviceAccount:service-${var.project_number}@gcp-sa-ekms.iam.gserviceaccount.com",
    "secretmanager.googleapis.com" = "serviceAccount:service-${var.project_number}@gcp-sa-secretmanager.iam.gserviceaccount.com",
    "cloudbuild.googleapis.com"    = "serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    "storage.googleapis.com"       = "serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com",
    "container.googleapis.com"     = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com",
    "compute.googleapis.com"       = "serviceAccount:service-${var.project_number}@compute-system.iam.gserviceaccount.com",
  }
}
