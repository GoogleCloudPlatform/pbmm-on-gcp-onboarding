# Create Admin Folder under Unclassified Parent Folder
# Admin folder would be created under Unclassified will be created. It will House Admin Projects like HostVPC, Logging.

module  "AdminUnclassified" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "${module.Unclassified.id}"

  names = [
    "Admin",
  ]
set_roles = true

}

