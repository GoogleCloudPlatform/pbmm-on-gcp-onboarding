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

prod_projects = {
  vmdemo_web = {
    user_defined_string            = ""               # Used to create project name - must be globally unique in aggregate
    additional_user_defined_string = "web"                  # check total 61 char limit with this addition
    billing_account                = "REPLACE_WITH_BILLING_ID" #"######-######-######"
    services = [
      "logging.googleapis.com"
    ]
    shared_vpc_service_config = {
      attach       = true
      host_project = "net-host-prj"
    }
    labels = {
      creator          = ""
      department       = "gcp"
      application_name = "vmdemoweb"
      environment      = "prod"
    }
  }
  vmdemo_app = {
    user_defined_string            = ""               # Used to create project name - must be globally unique in aggregate
    additional_user_defined_string = "app"                  # check total 61 char limit with this addition
    billing_account                = "REPLACE_WITH_BILLING_ID" #"######-######-######"
    services = [
      "logging.googleapis.com"
    ]
    shared_vpc_service_config = {
      attach       = true
      host_project = "net-host-prj"
    }
    labels = {
      creator          = ""
      department       = "gcp"
      application_name = "vmdemoapp"
      environment      = "prod"
    }
  }
  vmdemo_db = {
    user_defined_string            = ""               # Used to create project name - must be globally unique in aggregate
    additional_user_defined_string = "db"                   # check total 61 char limit with this addition
    billing_account                = "REPLACE_WITH_BILLING_ID" #"######-######-######"
    services = [
      "logging.googleapis.com"
    ]
    shared_vpc_service_config = {
      attach       = true
      host_project = "net-host-prj"
    }
    labels = {
      creator          = ""
      department       = "gcp"
      application_name = "vmdemodb"
      environment      = "prod"
    }
  }
  vmdemo-mono = {
    user_defined_string            = ""               # Used to create project name - must be globally unique in aggregate
    additional_user_defined_string = "mono"                 # check total 61 char limit with this addition
    billing_account                = "REPLACE_WITH_BILLING_ID" #"######-######-######"
    services = [
      "logging.googleapis.com"
    ]
    shared_vpc_service_config = {
      attach       = true
      host_project = "net-host-prj"
    }
    labels = {
      creator          = ""
      department       = "gcp"
      application_name = "vmdemomono"
      environment      = "prod"
    }
  }
}
