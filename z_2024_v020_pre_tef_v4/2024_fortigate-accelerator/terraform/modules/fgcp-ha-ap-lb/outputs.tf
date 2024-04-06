output fgt_mgmt_eips {
  value = google_compute_address.mgmt_pub[*].address
}

output fgt_password {
  value = google_compute_instance.fgt-vm[0].instance_id
}

output ilb {
  value = google_compute_forwarding_rule.ilb_fwd_rule.self_link
}

output fgt_umigs {
  value = google_compute_instance_group.fgt-umigs[*].self_link
}

output region {
  value = var.region
}

output health_check {
  value = google_compute_region_health_check.health_check.self_link
}

output internal_vpc {
  value = data.google_compute_subnetwork.subnets[1].network
}

output internal_subnet {
  value = data.google_compute_subnetwork.subnets[1].self_link
}

output api_key {
  value = random_string.api_key.result
}
