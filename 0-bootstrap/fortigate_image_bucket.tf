resource "google_storage_bucket" "fortigate_image_bucket" {
  name          = local.name
  location      = var.default_region
  force_destroy = true

  uniform_bucket_level_access = true
}

locals {
    name = "fortigate_image_bucket"
}