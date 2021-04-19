# Create Admin Folder under Protected B Parent Folder
# Admin folder would be created under Protected B will be created. It will House Admin Projects like HostVPC, Logging.

module  "DeptProtectedB" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "${module.ProtectedB.id}"

  names = [
    "${var.dept_name}",
  ]
set_roles = true

}


module  "DeptEnvProtectedB" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "${module.DeptProtectedB.id}"

  names = [
    "Dev",
    "Test",
    "Prod",
  ]
set_roles = true

}
