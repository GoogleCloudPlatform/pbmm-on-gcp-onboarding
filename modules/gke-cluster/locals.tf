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
  cluster_name = var.additional_user_defined_string == "" ? format("%s-cluster", var.user_defined_string) : format("%s-%s-cluster", var.user_defined_string, var.additional_user_defined_string)

  workload_identity_config = !var.enable_workload_identity ? [] : var.identity_namespace == null ? [{
    identity_namespace = "${var.project}.svc.id.google" }] : [{ identity_namespace = var.identity_namespace
  }]

  latest_version     = data.google_container_engine_versions.location.latest_master_version
  kubernetes_version = var.kubernetes_version != "latest" ? var.kubernetes_version : local.latest_version
  network_project    = var.network_project != "" ? var.network_project : var.project
}
