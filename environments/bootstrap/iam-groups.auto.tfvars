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

iam-groups = {
  id           = "security@terraform.landing.systems"
  display_name = "security"
  description  = "security group"
  domain       = "terraform.landing.systems"
  #owners       = ["root@terraform.landing.systems"]#, "tfsa0131@tzpe-tlz-tlz-de.iam.gserviceaccount.com"]
  #managers     = ["root@terraform.landing.systems"]
  members      = ["root@terraform.landing.systems"]
}
