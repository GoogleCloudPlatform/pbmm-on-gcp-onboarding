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
  default_user_defined_logging_metrics = var.default_logging_metrics_create ? [
    {
      name   = "default-gcs-bucket-metric"
      filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-iam-role-metric"
      filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\")"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-gce-route-metric"
      filter = "resource.type=\"gce_route\" AND (protoPayload.methodName=\"beta.compute.routes.patch\" OR protoPayload.methodName=\"beta.compute.routes.insert\")"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-gce-firewall-rule-metric"
      filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName=\"v1.compute.firewalls.patch\" OR protoPayload.methodName=\"v1.compute.firewalls.insert\")"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-cloudresourcemanager-api-metric"
      filter = "protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\" AND ((ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\"))"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-cloudsql-instances-update-metric"
      filter = "protoPayload.methodName=\"cloudsql.instances.update\""
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-SetIamPolicy-auditConfigDeltas-metric"
      filter = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-gce-network-metric"
      filter = "resource.type=\"gce_network\""
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-administrative-config-change-metric"
      filter = "log_id(\"cloudaudit.googleapis.com/activity\")"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    }
  ] : []
}
