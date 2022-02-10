/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

output "service_account" {
  value = {
    account_id = google_service_account.service_account.id
    email      = google_service_account.service_account.email
  }
}