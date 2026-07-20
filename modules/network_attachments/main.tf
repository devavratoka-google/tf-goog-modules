resource "google_compute_network_attachment" "this" {
  name                  = var.name
  project               = var.project
  region                = var.region
  description           = var.description
  connection_preference = var.connection_preference
  subnetworks           = var.subnetworks
  producer_accept_lists = var.producer_accept_lists
  producer_reject_lists = var.producer_reject_lists
}

resource "google_tags_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//compute.googleapis.com/projects/${var.project}/regions/${var.region}/networkAttachments/${google_compute_network_attachment.this.name}"
  tag_value = each.value
}