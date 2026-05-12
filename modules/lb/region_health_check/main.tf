resource "google_compute_region_health_check" "this" {
  name                = var.name
  region              = var.region
  description         = var.description
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    content {
      enable = log_config.value.enable
    }
  }

  dynamic "tcp_health_check" {
    for_each = var.tcp_health_check != null ? [var.tcp_health_check] : []
    content {
      port               = tcp_health_check.value.port
      port_specification = tcp_health_check.value.port_specification
      port_name          = tcp_health_check.value.port_name
      request            = tcp_health_check.value.request
      response           = tcp_health_check.value.response
      proxy_header       = tcp_health_check.value.proxy_header
    }
  }

  dynamic "http_health_check" {
    for_each = var.http_health_check != null ? [var.http_health_check] : []
    content {
      port               = http_health_check.value.port
      port_specification = http_health_check.value.port_specification
      port_name          = http_health_check.value.port_name
      host               = http_health_check.value.host
      request_path       = http_health_check.value.request_path
      response           = http_health_check.value.response
      proxy_header       = http_health_check.value.proxy_header
    }
  }

  dynamic "https_health_check" {
    for_each = var.https_health_check != null ? [var.https_health_check] : []
    content {
      port               = https_health_check.value.port
      port_specification = https_health_check.value.port_specification
      port_name          = https_health_check.value.port_name
      host               = https_health_check.value.host
      request_path       = https_health_check.value.request_path
      response           = https_health_check.value.response
      proxy_header       = https_health_check.value.proxy_header
    }
  }

  dynamic "http2_health_check" {
    for_each = var.http2_health_check != null ? [var.http2_health_check] : []
    content {
      port               = http2_health_check.value.port
      port_specification = http2_health_check.value.port_specification
      port_name          = http2_health_check.value.port_name
      host               = http2_health_check.value.host
      request_path       = http2_health_check.value.request_path
      response           = http2_health_check.value.response
      proxy_header       = http2_health_check.value.proxy_header
    }
  }

  dynamic "ssl_health_check" {
    for_each = var.ssl_health_check != null ? [var.ssl_health_check] : []
    content {
      port               = ssl_health_check.value.port
      port_specification = ssl_health_check.value.port_specification
      port_name          = ssl_health_check.value.port_name
      request            = ssl_health_check.value.request
      response           = ssl_health_check.value.response
      proxy_header       = ssl_health_check.value.proxy_header
    }
  }

  dynamic "grpc_health_check" {
    for_each = var.grpc_health_check != null ? [var.grpc_health_check] : []
    content {
      port               = grpc_health_check.value.port
      port_specification = grpc_health_check.value.port_specification
      port_name          = grpc_health_check.value.port_name
      grpc_service_name  = grpc_health_check.value.grpc_service_name
    }
  }
}