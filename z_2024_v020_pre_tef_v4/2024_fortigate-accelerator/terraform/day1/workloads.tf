data "google_compute_zones" "local" {
  project = data.terraform_remote_state.base.outputs.project
  region  = local.region
}

resource "google_compute_network" "tier1" {
  name                            = "${local.prefix}wrkld-vpc-tier1"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "tier1" {
  name          = "${local.prefix}wrkld-sb-tier1"
  region        = local.region
  network       = google_compute_network.tier1.self_link
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_firewall" "tier1" {
  name          = "${local.prefix}wrkld-fw-tier1-allowall"
  network       = google_compute_network.tier1.self_link
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol    = "all"
  }
}

resource "google_compute_network" "tier2" {
  name                            = "${local.prefix}wrkld-vpc-tier2"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "tier2" {
  name          = "${local.prefix}wrkld-sb-tier2"
  region        = local.region
  network       = google_compute_network.tier2.self_link
  ip_cidr_range = "10.1.0.0/16"
}

resource "google_compute_firewall" "tier2" {
  name          = "${local.prefix}wrkld-fw-tier2-allowall"
  network       = google_compute_network.tier2.self_link
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol    = "all"
  }
}

resource "google_compute_address" "wrkld_tier1" {
  name          = "${local.prefix}ip-wrkld-tier1"
  region        = local.region
  address_type  = "INTERNAL"
  subnetwork    = google_compute_subnetwork.tier1.self_link
}

resource "google_compute_instance" "wrkld_proxy" {
  name          = "${local.prefix}wrkld-tier1-proxy"
  zone          = data.google_compute_zones.local.names[0]
  machine_type  = "e2-micro"
  tags          = ["tier1"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  network_interface {
    subnetwork  = google_compute_subnetwork.tier1.self_link
    network_ip  = google_compute_address.wrkld_tier1.address
  }
  depends_on = [
    module.peer1,
    module.outbound
  ]
  metadata_startup_script = <<EOT
apt update;
apt -y install nginx
echo "server {
          listen 8080;
          location / {
          proxy_pass http://${google_compute_address.wrkld_tier2.address};
          }
        }" > /etc/nginx/sites-available/proxy.conf
ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy
systemctl restart nginx
EOT
}

resource "google_compute_address" "wrkld_tier2" {
  name          = "${local.prefix}ip-wrkld-tier2"
  region        = local.region
  address_type  = "INTERNAL"
  subnetwork    = google_compute_subnetwork.tier2.self_link
}

resource "google_compute_instance" "wrkld_websrv" {
  name          = "${local.prefix}wrkld-tier2-websrv"
  zone          = data.google_compute_zones.local.names[0]
  machine_type  = "e2-micro"
  tags          = ["tier2"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  network_interface {
    subnetwork  = google_compute_subnetwork.tier2.self_link
    network_ip  = google_compute_address.wrkld_tier2.address
  }
  depends_on = [
    module.peer2,
    module.outbound
  ]
  metadata_startup_script = <<EOT
apt update;
apt -y install nginx
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > /var/www/html/eicar.com
EOT
}
