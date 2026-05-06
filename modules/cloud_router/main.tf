################ Start Cloud Router ################

resource "google_compute_router" "this" {
  name        = var.name
  network     = var.network
  description = var.description
  bgp {
    asn                = var.asn
    advertise_mode     = var.advertise_mode
    advertised_groups  = var.advertised_groups
    keepalive_interval = var.keepalive_interval
    identifier_range   = var.identifier_range
    dynamic "advertised_ip_ranges" {
      for_each = var.advertised_ip_ranges
      content {
        range       = advertised_ip_ranges.value.range
        description = advertised_ip_ranges.value.description
      }
    }
  }
  encrypted_interconnect_router = var.encrypted_interconnect_router
  region                        = var.region
  project                       = var.project
}

################ End Cloud Router ################

################ Start Cloud Router Interfaces ################

resource "google_compute_router_interface" "this" {
  for_each                = var.router_interfaces
  name                    = each.value.interface_name
  router                  = google_compute_router.this.name
  region                  = google_compute_router.this.region
  project                 = google_compute_router.this.project
  ip_range                = each.value.ip_range
  ip_version              = each.value.ip_version
  vpn_tunnel              = each.value.vpn_tunnel
  interconnect_attachment = each.value.interconnect_attachment
  redundant_interface     = each.value.redundant_interface
  subnetwork              = each.value.subnetwork
  private_ip_address      = each.value.private_ip_address
}

################ End Cloud Router Interfaces################

################ Start Cloud Router Peers ################

resource "google_compute_router_peer" "this" {
  for_each                  = var.router_peers
  name                      = each.value.peer_name
  interface                 = each.value.interface
  peer_asn                  = each.value.peer_asn
  router                    = google_compute_router.this.name
  ip_address                = each.value.ip_address
  peer_ip_address           = each.value.peer_ip_address
  advertised_route_priority = each.value.advertised_route_priority
  # zero_advertised_route_priority = each.value.zero_advertised_route_priority
  advertise_mode    = each.value.advertise_mode
  advertised_groups = each.value.advertised_groups
  dynamic "advertised_ip_ranges" {
    for_each = each.value.advertised_ip_ranges
    content {
      range       = advertised_ip_ranges.value.range
      description = advertised_ip_ranges.value.description
    }
  }
  # custom_learned_route_priority = each.value.custom_learned_route_priority
  # dynamic "custom_learned_ip_ranges" {
  #   for_each = each.value.custom_learned_ip_ranges
  #   content {
  #     range = custom_learned_ip_ranges.value.range
  #   }
  # }
  dynamic "bfd" {
    for_each = each.value.bfd
    content {
      session_initialization_mode = bfd.value.session_initialization_mode
      min_receive_interval        = bfd.value.min_receive_interval
      min_transmit_interval       = bfd.value.min_transmit_interval
      multiplier                  = bfd.value.multiplier
    }
  }
  enable                    = each.value.enable
  router_appliance_instance = each.value.router_appliance_instance
  enable_ipv6               = each.value.enable_ipv6
  enable_ipv4               = each.value.enable_ipv4
  # ipv4_nexthop_address      = each.value.ipv4_nexthop_address
  # ipv6_nexthop_address      = each.value.ipv6_nexthop_address
  # peer_ipv4_nexthop_address = each.value.peer_ipv4_nexthop_address
  # peer_ipv6_nexthop_address = each.value.peer_ipv6_nexthop_address
  dynamic "md5_authentication_key" {
    for_each = each.value.md5_authentication_key
    content {
      name = md5_authentication_key.value.name
      key  = md5_authentication_key.value.key
    }
  }
  region  = google_compute_router.this.region
  project = google_compute_router.this.project

  # export_policies = each.value.export_policies
  # import_policies = each.value.import_policies
}

################ End Cloud Router Peers ################
