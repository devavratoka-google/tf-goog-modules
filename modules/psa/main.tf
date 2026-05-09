// Create a private connection

resource "google_service_networking_connection" "this" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = var.reserved_peering_ranges
  update_on_creation_fail = true
}

// Import or export custom routes
resource "google_compute_network_peering_routes_config" "this" {
  peering              = google_service_networking_connection.this.peering
  network              = var.network
  import_custom_routes = true
  export_custom_routes = true
}