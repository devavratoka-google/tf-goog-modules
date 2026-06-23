locals {
  has_ssl   = length(var.ssl_certificates) > 0
  has_hosts = length(var.hosts) > 0
  has_paths = length(var.path_rules) > 0
  # Path matcher is needed when either host-based or path-based routing is configured.
  needs_matcher = local.has_hosts || local.has_paths
}

resource "google_compute_region_url_map" "this" {
  name            = var.name
  region          = var.region
  default_service = var.default_service
  description     = var.description

  dynamic "host_rule" {
    for_each = local.needs_matcher ? [1] : []
    content {
      hosts        = local.has_hosts ? var.hosts : ["*"]
      path_matcher = "main-paths"
    }
  }

  dynamic "path_matcher" {
    for_each = local.needs_matcher ? [1] : []
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
                }
              }
            }
          }
        }
      }
    }
  }
}

# Creates HTTP proxy ONLY if no SSL cert is provided
resource "google_compute_region_target_http_proxy" "http" {
  count   = local.has_ssl ? 0 : 1
  name    = "${var.name}-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.this.id
}

# Creates HTTPS proxy ONLY if an SSL cert is provided
resource "google_compute_region_target_https_proxy" "https" {
  count            = local.has_ssl ? 1 : 0
  name             = "${var.name}-proxy"
  region           = var.region
  url_map          = google_compute_region_url_map.this.id
  ssl_certificates = var.ssl_certificates
  ssl_policy       = var.ssl_policy
}