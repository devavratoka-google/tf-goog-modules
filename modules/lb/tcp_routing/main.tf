resource "google_compute_region_target_tcp_proxy" "this" {
  name            = var.name
  region          = var.region
  description     = var.description
  backend_service = var.backend_service
  proxy_header    = var.proxy_header
}
