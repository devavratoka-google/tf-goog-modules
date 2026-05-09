# This module creates a firewall endpoint and association

resource "google_network_security_firewall_endpoint" "this" {
  name               = var.name
  parent             = var.parent
  location           = var.location
  billing_project_id = var.billing_project_id
  labels             = var.labels
}

resource "google_network_security_firewall_endpoint_association" "this" {
  for_each              = var.fw_ep_associations
  name                  = "${google_network_security_firewall_endpoint.this.name}-association-${each.key}"
  parent                = each.value.fw_ip_association_parent
  firewall_endpoint     = google_network_security_firewall_endpoint.this.id
  network               = each.value.network
  location              = each.value.fw_ip_association_location
  labels                = each.value.fw_ep_association_labels
  tls_inspection_policy = each.value.tls_inspection_policy
  disabled              = each.value.disabled
}