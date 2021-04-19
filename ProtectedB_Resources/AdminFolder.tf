# Create Admin Folder under Protected B Parent Folder
# Admin folder would be created under Protected B will be created. It will House Admin Projects like HostVPC, Logging.

module  "AdminProtectedB" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "${module.ProtectedB.id}"

  names = [
    "Admin",
  ]
set_roles = true

}

