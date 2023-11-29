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

# https://github.com/GoogleCloudPlatform/terraform-google-tags

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_key
resource "google_tags_tag_key" "key" {
  #parent = var.organization#"organizations/131880894992"
  parent = "organizations/131880894992"
  short_name = "environment"
  description = "custom tag description"
}

# value
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_value

resource "google_tags_tag_value" "value" {
    parent = "tagKeys/${google_tags_tag_key.key.name}"
    short_name = "prod"
    description = "tag value description"
}