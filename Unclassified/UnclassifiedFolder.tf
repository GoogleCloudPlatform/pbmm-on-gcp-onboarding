#provider "google" {
#  region      = "${var.region}"
#  credentials = "${file("${var.credentials_file_path}")}"
#}



# Parent Unclassified Folder
# Uncomment folder admin once IAM polices as per Orgganization needs have been decided
module  "Unclassified" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  =  "${var.parent_type}/${var.parent_id}"

  names = [
    "Unclassified",
  ]
set_roles = true

/*
  per_folder_admins = {
    admin = "group:admin-group@domain.com"
  }

  all_folder_admins = [
    "group:gcp-security@domain.com",
  ]
*/
}



