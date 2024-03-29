/**
 * Copyright 2019 Google LLC
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

output "cloudbuild_project_id" {
  description = "Project where CloudBuild configuration and terraform container image will reside."
  value       = data.google_project.project.project_id
}

output "cloudbuild_default_private_workerpool_id" {
  description = "The id of Cloud Build default private worker pool."
  value       = google_cloudbuild_worker_pool.default_private_workerpool.id
}

output "gcs_bucket_cloudbuild_artifacts" {
  description = "Bucket used to store Cloud/Build artefacts in CloudBuild project."
  value       = google_storage_bucket.cloudbuild_artifacts.name
}

output "tf_runner_artifact_repo" {
  description = "GAR Repo created to store runner images"
  value       = google_artifact_registry_repository.tf-image-repo.name
}
