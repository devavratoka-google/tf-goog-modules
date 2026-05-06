################ Start Subnetworks ################

resource "google_compute_subnetwork" "this" {
  name                    = var.name // just pass subnet role here, for eg pnat
  network                 = var.network
  description             = var.description
  ip_cidr_range           = var.ip_cidr_range
  reserved_internal_range = var.reserved_internal_range
  purpose                 = var.purpose
  role                    = var.role
  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_range
    content {
      range_name              = secondary_ip_range.value.range_name
      ip_cidr_range           = secondary_ip_range.value.ip_cidr_range
      reserved_internal_range = secondary_ip_range.value.reserved_internal_range
    }
  }
  private_ip_google_access   = var.private_ip_google_access
  private_ipv6_google_access = var.private_ipv6_google_access
  region                     = var.region
  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []

    content {
      aggregation_interval = try(log_config.value.aggregation_interval, null)
      flow_sampling        = try(log_config.value.flow_sampling, null)
      metadata             = try(log_config.value.metadata, null)
      metadata_fields      = try(log_config.value.metadata_fields, null)
      filter_expr          = try(log_config.value.filter_expr, null)
    }
  }
  stack_type                       = var.stack_type
  ipv6_access_type                 = var.ipv6_access_type
  external_ipv6_prefix             = var.external_ipv6_prefix
  project                          = var.project
  send_secondary_ip_range_if_empty = var.send_secondary_ip_range_if_empty
}

################ End Subnetworks ################