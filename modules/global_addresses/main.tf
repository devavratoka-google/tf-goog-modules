resource "google_compute_global_address" "this" {
  name          = var.name
  address       = var.address
  description   = var.description
  labels        = var.labels
  ip_version    = var.ip_version
  prefix_length = var.prefix_length
  address_type  = var.address_type
  purpose       = var.purpose
  network       = var.network
  project       = var.project
}