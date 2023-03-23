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

resource "google_kms_key_ring" "default_global_keyring" {
  count    = var.enable_default_global_cmk ? 1 : 0
  name     = "default-global-key-ring"
  location = "global"
  project  = var.project_id
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_kms_crypto_key" "default_global_customer_managed_key" {
  count    = var.enable_default_global_cmk ? 1 : 0
  name     = "default-global-customer-managed-key"
  key_ring = google_kms_key_ring.default_global_keyring[0].id
  # Must be in seconds - at most 90 days to comply with PBMM
  rotation_period = "7776000s"
  # Must be in seconds. Must be between 24 hours and 120 days - 7 days in this example
  destroy_scheduled_duration = "604800s"

  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
    # Must be SOFTWARE or HSM
    protection_level = "SOFTWARE"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    google_kms_key_ring.default_global_keyring
  ]
}

resource "google_kms_key_ring" "default_regional_keyring" {
  name     = "default-regional-key-ring"
  location = var.default_region
  project  = var.project_id
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_kms_crypto_key" "default_regional_customer_managed_key" {
  name     = "default-regional-customer-managed-key"
  key_ring = google_kms_key_ring.default_regional_keyring.id
  # Must be in seconds - at most 90 days to comply with PBMM
  rotation_period = "7776000s"
  # Must be in seconds. Must be between 24 hours and 120 days - 7 days in this example
  destroy_scheduled_duration = "604800s"

  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
    # Must be SOFTWARE or HSM
    protection_level = "SOFTWARE"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    google_kms_key_ring.default_regional_keyring
  ]
}

resource "google_project_iam_member" "custom_kms_encrypterdecrypter_serviceagents" {
  for_each = local.kms_supported_serviceagents
  project  = var.project_id
  role     = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member   = each.value
}

resource "google_kms_crypto_key_iam_member" "kms_supported_service_default_global_key_iam_members" {
  for_each      = toset(var.enable_default_global_cmk ? var.cmk_encrypterdecrypter_members : [])
  crypto_key_id = google_kms_crypto_key.default_global_customer_managed_key[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = each.value
  depends_on = [
    google_kms_crypto_key.default_global_customer_managed_key
  ]
}

resource "google_kms_crypto_key_iam_member" "kms_supported_service_default_regional_key_iam_members" {
  for_each      = toset(var.cmk_encrypterdecrypter_members)
  crypto_key_id = google_kms_crypto_key.default_regional_customer_managed_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = each.value
  depends_on = [
    google_kms_crypto_key.default_regional_customer_managed_key
  ]
}
