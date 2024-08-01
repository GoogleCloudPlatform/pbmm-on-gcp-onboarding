################################################################################
resource "google_network_connectivity_policy_based_route" "prod_app_to_data" {
  name        = "prod-app-to-data"
  description = "Route prod app to data"
  network     = "projects/${local.prod_vpc_project_id}/global/networks/${local.prod_vpc_name}"
  priority    = "900"
  project     = local.prod_vpc_project_id

  filter {
    protocol_version = "IPV4"
    ip_protocol      = "ALL"
    src_range        = local.prod_app_snet_range
    dest_range       = local.prod_data_snet_range
  }

  next_hop_ilb_ip = local.internal_ilb_address

  virtual_machine {
    tags = ["prod-app-to-data"]
  }

  labels = {
    env = "production"
  }
}

################################################################################
resource "google_network_connectivity_policy_based_route" "prod_pub_to_app" {
  name        = "prod-pub-to-app"
  description = "Route prod public to app"
  network     = "projects/${local.prod_vpc_project_id}/global/networks/${local.prod_vpc_name}"
  priority    = "900"
  project     = local.prod_vpc_project_id

  filter {
    protocol_version = "IPV4"
    ip_protocol      = "ALL"
    src_range        = local.prod_pub_snet_range
    dest_range       = local.prod_app_snet_range
  }

  next_hop_ilb_ip = local.internal_ilb_address

  virtual_machine {
    tags = ["prod-pub-to-app"]
  }

  labels = {
    env = "production"
  }
}

################################################################################
resource "google_network_connectivity_policy_based_route" "nprod_app_to_data" {
  name        = "nprod-app-to-data"
  description = "Route nprod app to data"
  network     = "projects/${local.nprod_vpc_project_id}/global/networks/${local.nprod_vpc_name}"
  priority    = "900"
  project     = local.nprod_vpc_project_id

  filter {
    protocol_version = "IPV4"
    ip_protocol      = "ALL"
    src_range        = local.nprod_app_snet_range
    dest_range       = local.nprod_data_snet_range
  }

  next_hop_ilb_ip = local.internal_ilb_address

  virtual_machine {
    tags = ["nprod-app-to-data"]
  }

  labels = {
    env = "nonproduction"
  }
}

################################################################################
resource "google_network_connectivity_policy_based_route" "nprod_pub_to_app" {
  name        = "nprod-pub-to-app"
  description = "Route nprod public to app"
  network     = "projects/${local.nprod_vpc_project_id}/global/networks/${local.nprod_vpc_name}"
  priority    = "900"
  project     = local.nprod_vpc_project_id

  filter {
    protocol_version = "IPV4"
    ip_protocol      = "ALL"
    src_range        = local.nprod_pub_snet_range
    dest_range       = local.nprod_app_snet_range
  }

  next_hop_ilb_ip = local.internal_ilb_address

  virtual_machine {
    tags = ["nprod-pub-to-app"]
  }

  labels = {
    env = "nonproduction"
  }
}

################################################################################
resource "google_network_connectivity_policy_based_route" "dev_app_to_data" {
  name        = "dev-app-to-data"
  description = "Route dev app to data"
  network     = "projects/${local.dev_vpc_project_id}/global/networks/${local.dev_vpc_name}"
  priority    = "900"
  project     = local.dev_vpc_project_id

  filter {
    protocol_version = "IPV4"
    ip_protocol      = "ALL"
    src_range        = local.dev_app_snet_range
    dest_range       = local.dev_data_snet_range
  }

  next_hop_ilb_ip = local.internal_ilb_address

  virtual_machine {
    tags = ["dev-app-to-data"]
  }

  labels = {
    env = "development"
  }
}

################################################################################
resource "google_network_connectivity_policy_based_route" "dev_pub_to_app" {
  name        = "dev-pub-to-app"
  description = "Route dev public to app"
  network     = "projects/${local.dev_vpc_project_id}/global/networks/${local.dev_vpc_name}"
  priority    = "900"
  project     = local.dev_vpc_project_id

  filter {
    protocol_version = "IPV4"
    ip_protocol      = "ALL"
    src_range        = local.dev_pub_snet_range
    dest_range       = local.dev_app_snet_range
  }

  next_hop_ilb_ip = local.internal_ilb_address

  virtual_machine {
    tags = ["dev-pub-to-app"]
  }

  labels = {
    env = "development"
  }
}


################################################################################

