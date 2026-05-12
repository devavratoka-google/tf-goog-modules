resource "google_compute_forwarding_rule" "this" {
  name                  = var.name
  region                = var.region
  description           = var.description
  network               = var.network
  subnetwork            = var.subnetwork
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  ports                 = length(var.ports) > 0 ? var.ports : null
  port_range            = var.port_range
  backend_service       = var.backend_service
  target                = var.target
  load_balancing_scheme = var.load_balancing_scheme
  allow_global_access   = var.allow_global_access
  network_tier          = var.network_tier
  labels                = var.labels

  dynamic "service_directory_registrations" {
    for_each = var.service_directory_registrations != null ? [var.service_directory_registrations] : []
    content {
      namespace = service_directory_registrations.value.namespace
      service   = service_directory_registrations.value.service
    }
  }
}