locals {
  is_all_apis = var.target_google_api == "all-apis"
  address_self_link = local.is_all_apis ? google_compute_global_address.this[0].self_link : google_compute_address.this[0].self_link
}

resource "google_compute_address" "this" {
  count = local.is_all_apis ? 0 : 1

  project      = var.project
  name         = var.address_name
  description  = "Reserved IP for PSC Endpoint"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = var.subnetwork
  region       = var.region
  address      = var.address
}

resource "google_compute_global_address" "this" {
  count = local.is_all_apis ? 1 : 0

  project      = var.project
  name         = var.address_name
  description  = "Reserved Global IP for PSC Endpoint"
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = var.network
  address      = var.address
}

resource "google_network_connectivity_regional_endpoint" "this" {
  count = (var.target_google_api != null && var.target_google_api != "all-apis") ? 1 : 0

  project           = var.project
  name              = var.address_name
  location          = var.region
  target_google_api = var.target_google_api
  access_type       = var.access_type
  network           = var.network
  subnetwork        = var.access_type == "REGIONAL" || var.regional_endpoint_subnetwork ? var.subnetwork : null

  address = "projects/${var.project}/regions/${var.region}/addresses/${var.address_name}"
}

resource "google_compute_global_forwarding_rule" "google_apis" {
  count = var.target_google_api == "all-apis" ? 1 : 0

  project                 = var.project
  name                    = var.forwarding_rule_name != null ? var.forwarding_rule_name : "${var.address_name}-fr"
  network                 = var.network
  ip_address              = local.address_self_link
  target                  = "all-apis"
  load_balancing_scheme   = ""
}

resource "google_compute_forwarding_rule" "this" {
  count = var.target_service_attachment != null ? 1 : 0

  project                 = var.project
  name                    = var.forwarding_rule_name != null ? var.forwarding_rule_name : "${var.address_name}-fr"
  region                  = var.region
  network                 = var.network
  ip_address              = local.address_self_link
  target                  = var.target_service_attachment
  load_balancing_scheme   = ""
  allow_psc_global_access = var.allow_psc_global_access
  no_automate_dns_zone    = var.no_automate_dns_zone
}

resource "google_compute_service_attachment" "this" {
  count = var.service_attachment != null ? 1 : 0

  project               = var.project
  name                  = var.service_attachment.name
  description           = var.service_attachment.description
  region                = var.region
  target_service        = var.service_attachment.target_service
  nat_subnets           = var.service_attachment.nat_subnets
  connection_preference = var.service_attachment.connection_preference
  enable_proxy_protocol = var.service_attachment.enable_proxy_protocol
  reconcile_connections = var.service_attachment.reconcile_connections
  domain_names          = var.service_attachment.domain_names
  consumer_reject_lists = var.service_attachment.consumer_reject_lists

  dynamic "consumer_accept_lists" {
    for_each = var.service_attachment.consumer_accept_lists != null ? var.service_attachment.consumer_accept_lists : []
    content {
      project_id_or_num = consumer_accept_lists.value.project_id_or_num
      connection_limit  = consumer_accept_lists.value.connection_limit
    }
  }
}
