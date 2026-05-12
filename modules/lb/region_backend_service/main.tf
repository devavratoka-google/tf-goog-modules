resource "google_compute_region_backend_service" "this" {
  name                            = var.name
  region                          = var.region
  description                     = var.description
  load_balancing_scheme           = var.load_balancing_scheme
  protocol                        = var.protocol
  port_name                       = var.load_balancing_scheme == "INTERNAL" ? null : var.port_name
  timeout_sec                     = var.timeout_sec
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  health_checks                   = length(var.health_checks) > 0 ? var.health_checks : null
  enable_cdn                      = var.enable_cdn

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    content {
      enable      = log_config.value.enable
      sample_rate = log_config.value.sample_rate
    }
  }

  dynamic "backend" {
    for_each = var.backends
    content {
      group                        = backend.value.group
      balancing_mode               = backend.value.balancing_mode
      capacity_scaler              = backend.value.capacity_scaler
      description                  = backend.value.description
      failover                     = backend.value.failover
      max_connections              = backend.value.max_connections
      max_connections_per_endpoint = backend.value.max_connections_per_endpoint
      max_connections_per_instance = backend.value.max_connections_per_instance
      max_rate                     = backend.value.max_rate
      max_rate_per_endpoint        = backend.value.max_rate_per_endpoint
      max_rate_per_instance        = backend.value.max_rate_per_instance
      max_utilization              = backend.value.max_utilization
    }
  }
}