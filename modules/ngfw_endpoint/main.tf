# This module creates a firewall endpoint and association

# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(var.labels, {})
}

resource "google_network_security_firewall_endpoint" "this" {
  name               = var.name
  parent             = var.parent
  location           = var.location
  billing_project_id = var.billing_project_id
  labels             = module.label_governance.validated_labels
}

resource "google_network_security_firewall_endpoint_association" "this" {
  for_each              = var.fw_ep_associations
  name                  = "${google_network_security_firewall_endpoint.this.name}-association-${each.key}"
  parent                = each.value.fw_ip_association_parent
  firewall_endpoint     = google_network_security_firewall_endpoint.this.id
  network               = each.value.network
  location              = each.value.fw_ip_association_location
  labels                = merge(module.label_governance.validated_labels, each.value.fw_ep_association_labels)
  tls_inspection_policy = each.value.tls_inspection_policy
  disabled              = each.value.disabled
}

resource "google_tags_location_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//networksecurity.googleapis.com/${google_network_security_firewall_endpoint.this.id}"
  tag_value = each.value
  location  = var.location
}