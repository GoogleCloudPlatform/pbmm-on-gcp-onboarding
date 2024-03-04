
output elb_frule {
  value = google_compute_forwarding_rule.elb_frule.self_link
}

output public_ip {
  value = google_compute_address.elb_eip.address
}
