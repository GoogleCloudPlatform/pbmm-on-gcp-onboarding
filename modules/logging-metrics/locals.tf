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
      filter = "resource.type=gcs_bucket"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-iam-role-metric"
      filter = "resource.type=iam_role"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-gce-route-metric"
      filter = "resource.type=gce_route"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-gce-firewall-rule-metric"
      filter = "resource.type=gce_firewall_rule"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-cloudresourcemanager-api-metric"
      filter = "(protoPayload.serviceName=cloudresourcemanager.googleapis.com)"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-cloudsql-instances-update-metric"
      filter = "protoPayload.methodName=cloudsql.instances.update"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-SetIamPolicy-auditConfigDeltas-metric"
      filter = "protoPayload.methodName=SetIamPolicy AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
      metric_descriptor = {
        metric_kind = "DELTA"
        value_type  = "INT64"
      }
    },
    {
      name   = "default-gce-network-metric"
      filter = "resource.type=gce_network"
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
