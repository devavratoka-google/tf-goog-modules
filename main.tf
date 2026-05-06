module "networks" {

  source   = "./modules/vpc"
  for_each = var.vpcs

  project_id   = local.project_id
  network_name = each.key
  routing_mode = each.value.routing_mode
  description  = each.value.description
  # auto_create_subnetworks                   = each.value.auto_create_subnetworks
  auto_create_subnetworks                   = false
  delete_default_internet_gateway_routes    = each.value.delete_default_internet_gateway_routes
  mtu                                       = each.value.mtu
  enable_ipv6_ula                           = each.value.enable_ipv6_ula
  internal_ipv6_range                       = each.value.internal_ipv6_range
  network_firewall_policy_enforcement_order = each.value.network_firewall_policy_enforcement_order
  network_profile                           = each.value.network_profile
  bgp_best_path_selection_mode              = each.value.bgp_best_path_selection_mode
  bgp_always_compare_med                    = each.value.bgp_always_compare_med
  bgp_inter_region_cost                     = each.value.bgp_inter_region_cost

}

module "subnetworks" {

  depends_on = [module.networks]

  source   = "./modules/subnetworks"
  for_each = var.subnetworks

  name                             = each.key
  network                          = module.networks[each.value.network_name].network_self_link
  description                      = each.value.description
  ip_cidr_range                    = each.value.ip_cidr_range
  reserved_internal_range          = each.value.reserved_internal_range
  purpose                          = each.value.purpose
  role                             = each.value.role
  private_ip_google_access         = each.value.private_ip_google_access
  private_ipv6_google_access       = each.value.private_ipv6_google_access
  region                           = each.value.region
  stack_type                       = each.value.stack_type
  ipv6_access_type                 = each.value.ipv6_access_type
  external_ipv6_prefix             = each.value.external_ipv6_prefix
  send_secondary_ip_range_if_empty = each.value.send_secondary_ip_range_if_empty
  secondary_ip_range               = each.value.secondary_ip_range
  log_config                       = each.value.log_config
  project                          = module.networks[each.value.network_name].network_project // local.project_id
}

module "cloud_routers" {

  depends_on = [module.networks]

  source   = "./modules/cloud_router"
  for_each = var.cloud_routers

  // Cloud Router
  name    = each.value.name
  network = module.networks[each.value.network_name].network_self_link
  // each.value.network
  description                   = each.value.description
  asn                           = each.value.asn
  advertise_mode                = each.value.advertise_mode
  advertised_groups             = each.value.advertised_groups
  keepalive_interval            = each.value.keepalive_interval
  identifier_range              = each.value.identifier_range
  advertised_ip_ranges          = each.value.advertised_ip_ranges
  encrypted_interconnect_router = each.value.encrypted_interconnect_router
  region                        = each.value.region
  project                       = module.networks[each.value.network_name].network_project

  // Router Interfaces
  router_interfaces = each.value.router_interfaces

  // Router Peers  
  router_peers = each.value.router_peers
}

module "cloud_nat" {

  depends_on = [module.networks, module.subnetworks, module.cloud_routers]

  source   = "./modules/cloud_nat"
  for_each = var.cloud_nats

  name                               = each.value.name
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnetwork_ip_ranges_to_nat
  router                             = module.cloud_routers[each.value.router_name].router_name
  nat_ip_allocate_option             = each.value.nat_ip_allocate_option
  # initial_nat_ips                     = each.value.initial_nat_ips
  nat_ips = each.value.nat_ips
  # drain_nat_ips                       = each.value.drain_nat_ips
  min_ports_per_vm                    = each.value.min_ports_per_vm
  max_ports_per_vm                    = each.value.max_ports_per_vm
  enable_dynamic_port_allocation      = each.value.enable_dynamic_port_allocation
  udp_idle_timeout_sec                = each.value.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = each.value.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = each.value.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = each.value.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = each.value.tcp_time_wait_timeout_sec
  endpoint_types                      = each.value.endpoint_types
  enable_endpoint_independent_mapping = each.value.enable_endpoint_independent_mapping
  type                                = each.value.type
  auto_network_tier                   = each.value.auto_network_tier
  region                              = each.value.region
  project                             = module.cloud_routers[each.value.router_name].router_project
  subnetwork                          = each.value.subnetwork
  # log_config                          = each.value.log_config
  enable = each.value.enable
  filter = each.value.filter
  rules  = each.value.rules
}

module "static_routes" {

  depends_on = [module.networks]

  source   = "./modules/static_routes"
  for_each = var.static_routes

  dest_range             = each.value.dest_range
  name                   = each.key
  network                = module.networks[each.value.network_name].network_self_link
  description            = each.value.description
  priority               = each.value.priority
  tags                   = each.value.tags
  next_hop_gateway       = each.value.next_hop_gateway
  next_hop_instance      = each.value.next_hop_instance
  next_hop_ip            = each.value.next_hop_ip
  next_hop_vpn_tunnel    = each.value.next_hop_vpn_tunnel
  next_hop_ilb           = each.value.next_hop_ilb
  project                = module.networks[each.value.network_name].network_project
  next_hop_instance_zone = each.value.next_hop_instance_zone
  resource_manager_tags  = each.value.resource_manager_tags
}

module "subnet_iam_bindings" {

  depends_on = [module.subnetworks]

  source   = "./modules/subnet_iam_binding"
  for_each = var.subnet_iam_bindings

  subnetwork = module.subnetworks[each.value.subnetwork_name].subnets_name
  role       = each.value.role
  members    = each.value.members
  project    = module.subnetworks[each.value.subnetwork_name].subnets_project
  region     = module.subnetworks[each.value.subnetwork_name].subnets_region
}

# module "vlan-attachments" {
#   depends_on               = [google_compute_router.cr-vlanatt-test]
#   source                   = "./modules/vlan_attachment"
#   router                   = "cr-vlanatt-test"
#   name                     = "vlan-att-test-a"
#   region                   = local.primary_region
#   project                  = local.project_id
#   admin_enabled            = true
#   edge_availability_domain = "AVAILABILITY_DOMAIN_1"
#   // Flow Logs
#   vpc_flow_logs_config_id = "vpc-flowlog-vlan-att-test-a"
#   state                   = "ENABLED"
#   aggregation_interval    = "INTERVAL_10_MIN"
#   flow_sampling           = 1.0
# }
