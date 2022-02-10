/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

locals {
    module_labels = {
        date_modified = formatdate("YYYY-MM-DD",timestamp())
    }
  
    labels  = merge(var.projectlabels, local.module_labels)
}