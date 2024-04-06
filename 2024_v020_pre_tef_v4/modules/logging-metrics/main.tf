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

resource "google_logging_metric" "default_user_defined_logging_metrics" {
  for_each = { for loggingmetric in local.default_user_defined_logging_metrics : loggingmetric.name => loggingmetric }
  project  = var.project_id
  name     = each.value.name
  filter   = each.value.filter
  metric_descriptor {
    metric_kind = each.value.metric_descriptor.metric_kind
    value_type  = each.value.metric_descriptor.value_type
  }
  depends_on = []
}

resource "google_logging_metric" "additional_user_defined_logging_metrics" {
  for_each = { for loggingmetric in var.additional_user_defined_logging_metrics : loggingmetric.name => loggingmetric }
  project  = var.project_id
  name     = each.value.name
  filter   = each.value.filter
  metric_descriptor {
    metric_kind = each.value.metric_descriptor.metric_kind
    value_type  = each.value.metric_descriptor.value_type
  }
  depends_on = []
}
