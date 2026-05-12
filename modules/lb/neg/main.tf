# ---------------------------------------------------------
# 1. ZONAL NEG (Used for standard GCE VM endpoints)
# ---------------------------------------------------------
resource "google_compute_network_endpoint_group" "zonal" {
  count = var.network_endpoint_type != "SERVERLESS" ? 1 : 0

  name                  = var.name
  network_endpoint_type = var.network_endpoint_type
  description           = var.description
  network               = var.network
  subnetwork            = var.subnetwork
  default_port          = var.default_port
  zone                  = var.zone
}

# ---------------------------------------------------------
# 2. ZONAL NEG ENDPOINTS (Attaches VMs to the Zonal NEG)
# ---------------------------------------------------------
resource "google_compute_network_endpoint" "zonal_endpoints" {
  # Only iterate if it's a Zonal NEG, otherwise ignore endpoints entirely
  for_each = var.network_endpoint_type != "SERVERLESS" ? var.endpoints : {}

  network_endpoint_group = google_compute_network_endpoint_group.zonal[0].name
  zone                   = google_compute_network_endpoint_group.zonal[0].zone

  instance   = each.value.instance
  ip_address = each.value.ip_address
  port       = each.value.port
}

# ---------------------------------------------------------
# 3. REGIONAL NEG (Used for Serverless - Cloud Run/Functions)
# ---------------------------------------------------------
resource "google_compute_region_network_endpoint_group" "serverless" {
  count = var.network_endpoint_type == "SERVERLESS" ? 1 : 0

  name                  = var.name
  network_endpoint_type = var.network_endpoint_type
  description           = var.description
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork

  dynamic "cloud_run" {
    for_each = var.cloud_run != null ? [var.cloud_run] : []
    content {
      service  = cloud_run.value.service
      tag      = cloud_run.value.tag
      url_mask = cloud_run.value.url_mask
    }
  }

  dynamic "cloud_function" {
    for_each = var.cloud_function != null ? [var.cloud_function] : []
    content {
      function = cloud_function.value.function
      url_mask = cloud_function.value.url_mask
    }
  }

  dynamic "app_engine" {
    for_each = var.app_engine != null ? [var.app_engine] : []
    content {
      service  = app_engine.value.service
      version  = app_engine.value.version
      url_mask = app_engine.value.url_mask
    }
  }
}