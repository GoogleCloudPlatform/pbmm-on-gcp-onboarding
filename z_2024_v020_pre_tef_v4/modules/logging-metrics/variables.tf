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

variable "project_id" {
  description = "project ID to use for creating logging metrics."
  default     = ""
  type        = string
}

variable "default_logging_metrics_create" {
  description = "Boolean to determine if default logging metrics should be created"
  type        = bool
  default     = true
}

variable "additional_user_defined_logging_metrics" {
  type = list(object({
    name   = string
    filter = string
    metric_descriptor = object({
      metric_kind = string
      value_type  = string
    })
  }))
  description = "Additional used-defined logging metrics"
  default     = []
}
