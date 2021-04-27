# Create Admin Folder under Unclassified Parent Folder
# Admin folder would be created under Unnclassified will be created. It will House Admin Projects like HostVPC, Logging.

module  "DeptUnclassified" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "${module.Unclassified.id}"

  names = [
    "${var.dept_name}",
  ]
set_roles = true

}


module  "DeptEnvUnclassified" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "${module.DeptUnclassified.id}"

  names = [
    "Dev",
    "Test",
    "Prod",
  ]
set_roles = true

}
