################ Start Cloud NAT ################

resource "google_compute_router_nat" "this" {
  name                               = var.name
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  router                             = var.router
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  # initial_nat_ips                     = var.initial_nat_ips
  nat_ips = var.nat_ips
  # drain_nat_ips                       = var.drain_nat_ips
  min_ports_per_vm                    = var.min_ports_per_vm
  max_ports_per_vm                    = var.max_ports_per_vm
  enable_dynamic_port_allocation      = var.enable_dynamic_port_allocation
  udp_idle_timeout_sec                = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = var.tcp_time_wait_timeout_sec
  endpoint_types                      = var.endpoint_types
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping
  type                                = var.type
  auto_network_tier                   = var.auto_network_tier
  region                              = var.region
  project                             = var.project
  dynamic "subnetwork" {
    for_each = var.subnetwork
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = subnetwork.value.secondary_ip_range_names
    }
  }
  # dynamic "log_config" {
  #   for_each = var.log_config
  #   content {
  #     enable = log_config.value.enable
  #     filter = log_config.value.filter
  #   }
  # }
  log_config {
    enable = var.enable
    filter = var.filter
  }
  dynamic "rules" {
    for_each = var.rules
    content {
      rule_number = rules.value.rule_number
      description = rules.value.description
      match       = rules.value.match
      action {
        source_nat_active_ips = rules.value.action.source_nat_active_ips
        source_nat_drain_ips  = rules.value.action.source_nat_drain_ips
        # source_nat_active_ranges = rules.value.action.source_nat_active_ranges
        # source_nat_drain_ranges = rules.value.action.source_nat_drain_ranges
      }

    }
  }
}

################ End Cloud NAT ################
