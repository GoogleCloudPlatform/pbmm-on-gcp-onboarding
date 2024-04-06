data "terraform_remote_state" "base" {
  backend = "local"

  config = {
    path = "../day0/terraform.tfstate"
  }
}
