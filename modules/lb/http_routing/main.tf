resource "google_compute_region_url_map" "this" {
  name            = var.name
  region          = var.region
  default_service = var.default_service
  description     = var.description

  # Only creates the host rule if you pass hosts or path rules into the module
  dynamic "host_rule" {
    for_each = length(var.hosts) > 0 || length(var.path_rules) > 0 ? [1] : []
    content {
      hosts        = length(var.hosts) > 0 ? var.hosts : ["*"]
      path_matcher = "main-paths"
    }
  }

  dynamic "path_matcher" {
    for_each = length(var.hosts) > 0 || length(var.path_rules) > 0 ? [1] : []
    content {
      name            = "main-paths"
      default_service = var.default_service

      dynamic "path_rule" {
        for_each = var.path_rules
        content {
          paths   = path_rule.value.paths
          service = path_rule.value.service

          dynamic "route_action" {
            for_each = path_rule.value.route_action != null ? [path_rule.value.route_action] : []
            content {
              dynamic "url_rewrite" {
                for_each = route_action.value.url_rewrite != null ? [route_action.value.url_rewrite] : []
                content {
                  path_prefix_rewrite = url_rewrite.value.path_prefix_rewrite
                  host_rewrite        = try(url_rewrite.value.host_rewrite, null)
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "google_compute_region_ssl_certificate" "managed" {
  count       = var.ssl_certificate != null ? 1 : 0
  name_prefix = "${var.name}-cert-"
  region      = var.region
  certificate = var.ssl_certificate.certificate
  private_key = var.ssl_certificate.private_key

  lifecycle {
    create_before_destroy = true
  }
}

# Creates HTTP proxy ONLY if no SSL cert is provided
resource "google_compute_region_target_http_proxy" "http" {
  count   = (length(var.ssl_certificates) == 0 && var.ssl_certificate == null) ? 1 : 0
  name    = "${var.name}-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.this.id
}

# Creates HTTPS proxy ONLY if an SSL cert is provided
resource "google_compute_region_target_https_proxy" "https" {
  count  = (length(var.ssl_certificates) > 0 || var.ssl_certificate != null) ? 1 : 0
  name   = "${var.name}-proxy"
  region = var.region
  url_map = google_compute_region_url_map.this.id
  ssl_certificates = concat(
    var.ssl_certificates,
    var.ssl_certificate != null ? [google_compute_region_ssl_certificate.managed[0].id] : []
  )
  ssl_policy = var.ssl_policy
}