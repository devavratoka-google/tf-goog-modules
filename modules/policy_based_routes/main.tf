resource "google_network_connectivity_policy_based_route" "this" {
  name                  = var.name
  network               = var.network
  next_hop_other_routes = var.next_hop_other_routes
  next_hop_ilb_ip       = var.next_hop_ilb_ip
  priority              = var.priority
  project               = var.project

  # Only create this block if tags are actually provided
  dynamic "virtual_machine" {
    for_each = var.virtual_machine_tags != null && length(var.virtual_machine_tags) > 0 ? [1] : []
    content {
      tags = var.virtual_machine_tags
    }
  }

  filter {
    src_range        = var.src_range
    dest_range       = var.dest_range
    ip_protocol      = var.ip_protocol
    protocol_version = var.protocol_version
  }
}