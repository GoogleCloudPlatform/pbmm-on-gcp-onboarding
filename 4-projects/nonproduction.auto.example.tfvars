/**
 * Copyright 2021 Google LLC
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

location_kms = "us"
location_gcs = "US"
# to be verified in modules terraform-google-modules/kms/google
# and verify cmek_bucket_suffix = "${module.base_shared_vpc_project.project_id}-${lower(var.location_gcs)}-${random_string.bucket_name.result}"
# in terraform-google-modules/cloud-storage/google//modules/simple_bucket
# see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/424
#location_kms = "northamerica-northeast2"
#location_gcs = "northamerica-northeast2"