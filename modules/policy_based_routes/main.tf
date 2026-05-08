resource "google_network_connectivity_policy_based_route" "this" {
  name                  = var.name
  network               = var.network
  next_hop_other_routes = var.next_hop_other_routes
  next_hop_ilb_ip       = var.next_hop_ilb_ip
  priority              = var.priority
  project               = var.project

  virtual_machine {
    tags = var.virtual_machine_tags
  }

  filter {
    src_range        = var.src_range
    dest_range       = var.dest_range
    ip_protocol      = var.ip_protocol
    protocol_version = var.protocol_version
  }
}
