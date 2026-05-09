resource "google_network_connectivity_spoke" "this" {
  provider    = google-beta
  name        = var.name
  hub         = var.hub
  location    = var.location
  labels      = var.labels
  description = var.description
  group       = var.group
  project     = var.project
  dynamic "linked_interconnect_attachments" {
    for_each = var.linked_interconnect_attachments
    content {
      uris                       = linked_interconnect_attachments.value.uris
      site_to_site_data_transfer = linked_interconnect_attachments.value.site_to_site_data_transfer
      include_import_ranges      = linked_interconnect_attachments.value.include_import_ranges
      exclude_import_ranges      = linked_interconnect_attachments.value.exclude_import_ranges
      include_export_ranges      = linked_interconnect_attachments.value.include_export_ranges
      exclude_export_ranges      = linked_interconnect_attachments.value.exclude_export_ranges
    }
  }
  dynamic "linked_vpn_tunnels" {
    for_each = var.linked_vpn_tunnels
    content {
      uris                       = linked_vpn_tunnels.value.uris
      site_to_site_data_transfer = linked_vpn_tunnels.value.site_to_site_data_transfer
      include_import_ranges      = linked_vpn_tunnels.value.include_import_ranges
      exclude_import_ranges      = linked_vpn_tunnels.value.exclude_import_ranges
      include_export_ranges      = linked_vpn_tunnels.value.include_export_ranges
      exclude_export_ranges      = linked_vpn_tunnels.value.exclude_export_ranges
    }
  }
  dynamic "linked_vpc_network" {
    for_each = var.linked_vpc_network
    content {
      uri                   = linked_vpc_network.value.uri
      exclude_export_ranges = linked_vpc_network.value.exclude_export_ranges
      include_export_ranges = linked_vpc_network.value.include_export_ranges
    }
  }
  dynamic "linked_producer_vpc_network" {
    for_each = var.linked_producer_vpc_network
    content {
      network               = linked_producer_vpc_network.value.network
      peering               = linked_producer_vpc_network.value.peering
      include_export_ranges = linked_producer_vpc_network.value.include_export_ranges
      exclude_export_ranges = linked_producer_vpc_network.value.exclude_export_ranges
    }
  }
  dynamic "linked_router_appliance_instances" {
    for_each = var.linked_router_appliance_instances
    content {
      site_to_site_data_transfer = linked_router_appliance_instances.value.site_to_site_data_transfer
      include_import_ranges      = linked_router_appliance_instances.value.include_import_ranges
      exclude_import_ranges      = linked_router_appliance_instances.value.exclude_import_ranges
      include_export_ranges      = linked_router_appliance_instances.value.include_export_ranges
      exclude_export_ranges      = linked_router_appliance_instances.value.exclude_export_ranges
      dynamic "instances" {
        for_each = linked_router_appliance_instances.value.instances
        content {
          virtual_machine = instances.value.virtual_machine
          ip_address      = instances.value.ip_address
        }
      }
    }
  }
}

