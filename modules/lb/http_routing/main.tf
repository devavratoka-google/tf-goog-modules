resource "google_compute_region_url_map" "this" {
  name            = var.name
  region          = var.region
  default_service = var.default_service
  description     = var.description

  # Only creates the host rule if you pass hosts into the module
  dynamic "host_rule" {
    for_each = length(var.hosts) > 0 ? [1] : []
    content {
      hosts        = var.hosts
      path_matcher = "main-paths"
    }
  }

  dynamic "path_matcher" {
    for_each = length(var.hosts) > 0 ? [1] : []
    content {
      name            = "main-paths"
      default_service = var.default_service
    }
  }
}

# Creates HTTP proxy ONLY if no SSL cert is provided
resource "google_compute_region_target_http_proxy" "http" {
  count   = length(var.ssl_certificates) == 0 ? 1 : 0
  name    = "${var.name}-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.this.id
}

# Creates HTTPS proxy ONLY if an SSL cert is provided
resource "google_compute_region_target_https_proxy" "https" {
  count            = length(var.ssl_certificates) > 0 ? 1 : 0
  name             = "${var.name}-proxy"
  region           = var.region
  url_map          = google_compute_region_url_map.this.id
  ssl_certificates = var.ssl_certificates
}