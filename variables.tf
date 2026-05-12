variable "env_project_id" {
  type = string
}

variable "vpcs" {
  type = map(object({
    # project_id = string
    # network_name = string
    routing_mode = optional(string, "GLOBAL")
    description  = optional(string, "")
    # auto_create_subnetworks                   = optional(bool, false)
    delete_default_internet_gateway_routes    = optional(bool, false)
    mtu                                       = optional(number, 0)
    enable_ipv6_ula                           = optional(bool, false)
    internal_ipv6_range                       = optional(string, null)
    network_firewall_policy_enforcement_order = optional(string, null)
    network_profile                           = optional(string, null)
    bgp_best_path_selection_mode              = optional(string, "LEGACY")
    bgp_always_compare_med                    = optional(bool, false)
    bgp_inter_region_cost                     = optional(string, null)
  }))
}

variable "subnetworks" {
  type = map(object({
    network_name               = string
    description                = optional(string, null)
    ip_cidr_range              = string
    reserved_internal_range    = optional(string, null)
    purpose                    = optional(string, "PRIVATE")
    role                       = optional(string, null)
    private_ip_google_access   = optional(bool, null)
    private_ipv6_google_access = optional(string, null) // "DISABLE_GOOGLE_ACCESS"
    region                     = string
    secondary_ip_range = optional(map(object({
      range_name              = string
      ip_cidr_range           = string
      reserved_internal_range = optional(string, null)
    })), {})
    ipv6_access_type     = optional(string, null)
    external_ipv6_prefix = optional(string, null)
    log_config = object({
      aggregation_interval = optional(string, "INTERVAL_10_MIN")
      flow_sampling        = optional(number, 0.5)
      metadata             = optional(string, "INCLUDE_ALL_METADATA")
      metadata_fields      = optional(list(string), [])
      filter_expr          = optional(string, null)
      stack_type           = optional(string, "IPV4_ONLY")
    })
    stack_type                       = optional(string, "IPV4_ONLY")
    send_secondary_ip_range_if_empty = optional(bool, false)
  }))
}

variable "cloud_routers" {
  type = map(object({
    name              = string
    network_name      = string
    description       = optional(string, null)
    asn               = optional(number, 16550)
    advertise_mode    = optional(string, "DEFAULT")
    advertised_groups = optional(list(string), [])
    advertised_ip_ranges = optional(map(object({ // pass only if advertise_mode is custom
      range       = string
      description = optional(string, null)
    })), {})
    keepalive_interval            = optional(number, 20)
    identifier_range              = optional(string, null)
    encrypted_interconnect_router = optional(bool, false)
    region                        = string
    router_interfaces = map(object({
      interface_name          = string
      ip_range                = optional(string, null)
      ip_version              = optional(string, "IPV4")
      vpn_tunnel              = optional(string, null)
      subnetwork              = optional(string, null)
      private_ip_address      = optional(string, null)
      interconnect_attachment = optional(string, null)
      redundant_interface     = optional(string, null)
    }))
    router_peers = map(object({
      peer_name                 = string
      interface                 = string
      peer_asn                  = number
      ip_address                = optional(string, null)
      peer_ip_address           = string
      advertised_route_priority = optional(number, 100)
      advertise_mode            = optional(string, "DEFAULT")
      advertised_groups         = optional(list(string), [])
      advertised_ip_ranges = optional(map(object({
        range       = string
        description = string
      })), {})
      # custom_learned_route_priority = number
      # custom_learned_ip_ranges = map(object({
      #   range = string
      # }))
      bfd = optional(map(object({
        session_initialization_mode = string
        min_receive_interval        = number
        min_transmit_interval       = number
        multiplier                  = number
      })), {})
      enable                    = optional(bool, true)
      router_appliance_instance = optional(string, null)
      enable_ipv6               = optional(bool, false)
      enable_ipv4               = optional(bool, true)
      # ipv4_nexthop_address      = string
      # ipv6_nexthop_address      = string
      # peer_ipv4_nexthop_address = string
      # peer_ipv6_nexthop_address = string
      md5_authentication_key = optional(map(object({
        name = string
        key  = string
      })), {})
    }))
  }))
}

variable "cloud_nats" {
  type = map(object({
    name                               = string
    source_subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES")
    router_name                        = string
    nat_ip_allocate_option             = optional(string, "AUTO_ONLY")
    # initial_nat_ips                     = optional(set(string), [])
    nat_ips = optional(set(string), [])
    # drain_nat_ips                       = optional(set(string), [])
    min_ports_per_vm                    = optional(number, 64)
    max_ports_per_vm                    = optional(number, null)
    enable_dynamic_port_allocation      = optional(bool, false)
    udp_idle_timeout_sec                = optional(number, 30)
    icmp_idle_timeout_sec               = optional(number, 30)
    tcp_established_idle_timeout_sec    = optional(number, 1200)
    tcp_transitory_idle_timeout_sec     = optional(number, 30)
    tcp_time_wait_timeout_sec           = optional(number, 120)
    endpoint_types                      = optional(list(string), ["ENDPOINT_TYPE_VM"])
    enable_endpoint_independent_mapping = optional(bool, false)
    type                                = optional(string, "PUBLIC")
    auto_network_tier                   = optional(string, "PREMIUM")
    region                              = string
    # project                             = string
    subnetwork = optional(map(object({
      name                     = string
      source_ip_ranges_to_nat  = set(string)
      secondary_ip_range_names = set(string)
    })), {})
    # log_config = map(object({
    #   enable = bool
    #   filter = string
    # }))
    enable = optional(bool, false)
    filter = optional(string, "ALL")
    rules = optional(map(object({
      rule_number = number
      description = optional(string, null)
      match       = string
      action = object({
        source_nat_active_ips = list(string)
        source_nat_drain_ips  = list(string)
      })
    })), {})
  }))
}

variable "static_routes" {
  type = map(object({
    dest_range             = string
    network_name           = string
    description            = optional(string, null)
    priority               = number
    tags                   = optional(set(string), [])
    next_hop_gateway       = optional(string, null)
    next_hop_instance      = optional(string, null)
    next_hop_ip            = optional(string, null)
    next_hop_vpn_tunnel    = optional(string, null)
    next_hop_ilb           = optional(string, null)
    next_hop_instance_zone = optional(string, null)
    resource_manager_tags  = optional(map(string), {})
  }))
}

variable "policy_based_routes" {
  type = map(object({
    network_name          = string
    next_hop_other_routes = optional(string, null)
    next_hop_ilb_ip       = optional(string, null)
    priority              = number
    virtual_machine_tags  = optional(list(string), null)
    src_range             = string
    dest_range            = string
    ip_protocol           = optional(string, "ALL")
    protocol_version      = optional(string, "IPV4")
  }))
}

variable "vlan_attachments" {
  type = map(object({
    router_name              = string
    admin_enabled            = bool
    description              = optional(string, null)
    mtu                      = optional(number, 8896)
    edge_availability_domain = string
    type                     = optional(string, "PARTNER")
    vlan_tag8021q            = optional(string, null)
    encryption               = optional(string, "NONE")
    labels                   = optional(map(string), {})
    state                    = optional(string, "ENABLED")
    aggregation_interval     = optional(string, "INTERVAL_10_MIN")
    flow_sampling            = optional(number, 1.0)
    metadata                 = optional(string, "INCLUDE_ALL_METADATA")
  }))
}

variable "subnet_iam_bindings" {
  type = map(object({
    subnetwork_name = string
    role            = string
    members         = list(string)
  }))
}

variable "shared_vpcs" {
  type = map(object({
  }))
}

variable "ncc_hubs" {
  type = map(object({
    description     = optional(string, null)
    labels          = optional(map(string), {})
    preset_topology = optional(string, "STAR")
    export_psc      = optional(bool, true)
    ncc_groups = optional(map(object({
      description          = string
      auto_accept_projects = list(string)
    })), {})
  }))
}

variable "ncc_spokes" {
  type = map(object({
    name        = string
    hub_name    = string
    location    = optional(string, "global")
    labels      = optional(map(string), {})
    description = optional(string, null)
    group       = optional(string, null)
    project     = string
    linked_interconnect_attachments = optional(map(object({
      uris                       = optional(list(string), [])
      site_to_site_data_transfer = optional(bool, false)
      include_import_ranges      = optional(list(string), ["ALL_IPV4_RANGES"])
      exclude_import_ranges      = optional(list(string), [])
      include_export_ranges      = optional(list(string), [])
      exclude_export_ranges      = optional(list(string), [])
    })), {})
    linked_vpn_tunnels = optional(map(object({
      uris                       = optional(list(string), [])
      site_to_site_data_transfer = optional(bool, false)
      include_import_ranges      = optional(list(string), ["ALL_IPV4_RANGES"])
      exclude_import_ranges      = optional(list(string), [])
      include_export_ranges      = optional(list(string), [])
      exclude_export_ranges      = optional(list(string), [])
    })), {})
    linked_vpc_network = optional(map(object({
      uri                   = string
      exclude_export_ranges = optional(list(string), [])
      include_export_ranges = optional(list(string), [])
    })), {})
    linked_producer_vpc_network = optional(map(object({
      network = string
      peering = string
      # producer_network      = string
      include_export_ranges = optional(list(string), [])
      exclude_export_ranges = optional(list(string), [])
    })), {})
    linked_router_appliance_instances = optional(map(object({
      site_to_site_data_transfer = optional(bool, false)
      include_import_ranges      = optional(list(string), ["ALL_IPV4_RANGES"])
      exclude_import_ranges      = optional(list(string), [])
      include_export_ranges      = optional(list(string), [])
      exclude_export_ranges      = optional(list(string), [])
      instances = map(object({
        virtual_machine = string
        ip_address      = string
      }))
    })), {})
  }))
}

variable "dns_zones" {
  type = map(object({
    dns_name    = string
    description = optional(string, "Managed by Terraform")
    visibility  = optional(string, "private")
    networks    = optional(list(string), [])
    forwarding_config = optional(object({
      target_name_servers = list(object({
        ipv4_address    = string
        forwarding_path = optional(string, "default")
      }))
    }), null)
    peering_config = optional(object({
      target_network = string
    }), null)
    record_sets = optional(map(object({
      name    = string
      type    = string
      ttl     = number
      rrdatas = list(string)
    })), {})
    project = optional(string, null)
  }))
  default = {}
}

variable "dns_policies" {
  type = map(object({
    enable_inbound_forwarding = optional(bool, false)
    enable_logging            = optional(bool, false)
    networks                  = optional(list(string), [])
    project                   = optional(string, null)
  }))
  default = {}
}

variable "addresses" {
  type = map(object({
    description     = optional(string, null)
    address         = optional(string, null)
    address_type    = optional(string, "EXTERNAL")
    purpose         = optional(string, null)
    network_name    = optional(string, null)
    subnetwork_name = optional(string, null)
    region          = optional(string, null)
    project         = optional(string, null)
  }))
  default = {}
}

variable "global_addresses" {
  type = map(object({
    address       = string
    description   = optional(string, null)
    labels        = optional(map(string), {})
    ip_version    = optional(string, "IPV4")
    prefix_length = optional(number, 32) // not applicable for internal
    address_type  = optional(string, "INTERNAL")
    purpose       = optional(string, "PRIVATE_SERVICE_CONNECT")
    network_name  = string
  }))
}

variable "psa" {
  type = map(object({
    network_name                 = string
    reserved_peering_ranges_name = list(string)
  }))
}

variable "firewall_endpoints" {
  type = map(object({
    name               = string
    parent             = string
    location           = string
    billing_project_id = string
    labels             = optional(map(string), null)
    fw_ep_associations = map(object({
      fw_ip_association_parent   = string
      network                    = string
      fw_ip_association_location = string
      fw_ep_association_labels   = optional(map(string), null)
      tls_inspection_policy      = optional(string, null)
      disabled                   = optional(bool, false)
    }))
  }))
}

variable "hierarchical_fw_policies" {
  type = map(object({
    parent      = string // Required
    short_name  = string // Required
    description = optional(string, null)
    fw_policy_associations = map(object({
      attachment_target = string
      association_name  = string
    }))
    fw_policy_rules = map(object({
      priority           = number
      direction          = string
      action             = string // "allow", "deny", "goto_next" and "apply_security_profile_group"
      rule_name          = optional(string, null)
      disabled           = optional(bool, false)
      description        = optional(string, null)
      enable_logging     = optional(bool, false)
      target_secure_tags = optional(list(string))
      match = object({
        src_ip_ranges             = optional(list(string), [])
        src_fqdns                 = optional(list(string), [])
        src_region_codes          = optional(list(string), [])
        src_threat_intelligences  = optional(list(string), [])
        src_address_groups        = optional(list(string), [])
        dest_ip_ranges            = optional(list(string), [])
        dest_fqdns                = optional(list(string), [])
        dest_region_codes         = optional(list(string), [])
        dest_threat_intelligences = optional(list(string), [])
        dest_address_groups       = optional(list(string), [])
        src_secure_tags           = optional(list(string), [])
        layer4_configs = optional(list(object({
          ip_protocol = string
          ports       = optional(list(string), [])
        })))
      })
      security_profile_group  = optional(string, null)
      tls_inspect             = optional(bool, false)
      target_service_accounts = optional(list(string), [])
      target_resources        = optional(list(string), [])

    }))
  }))
  # default = {}
}

variable "global_nw_fw_policies" {
  type = map(object({
    nw_fw_policy_name        = string
    nw_fw_policy_description = string
    nw_fw_policy_project     = string
    association_targets      = map(string)
    nw_fw_policy_rules = map(object({
      action    = string
      direction = string
      # priority                = number
      # project                 = string
      description    = string
      disabled       = bool
      enable_logging = bool
      # rule_name               = string
      security_profile_group  = string
      target_service_accounts = list(string)
      tls_inspect             = bool
      target_secure_tags      = optional(list(string))
      match = object({
        src_ip_ranges             = optional(list(string), [])
        src_fqdns                 = optional(list(string), [])
        src_region_codes          = optional(list(string), [])
        src_threat_intelligences  = optional(list(string), [])
        src_address_groups        = optional(list(string), [])
        dest_ip_ranges            = optional(list(string), [])
        dest_fqdns                = optional(list(string), [])
        dest_region_codes         = optional(list(string), [])
        dest_threat_intelligences = optional(list(string), [])
        dest_address_groups       = optional(list(string), [])
        src_secure_tags           = optional(list(string), [])
        layer4_configs = map(object({
          ip_protocol = string
          ports       = list(string)
        }))
      })
    }))
  }))
}


variable "secure_tags" {
  type = map(object({
    parent             = string
    short_name         = string
    description        = string
    purpose_data       = map(string)
    iam_viewer_members = optional(list(string), [])
    iam_user_members   = optional(list(string), [])
    tag_values = map(object({
      tagvalue_short_name  = string
      tagvalue_description = string
    }))
  }))
}

variable "vpc_peerings" {
  type = map(object({
    local_network_peering_name                = string
    peer_network_peering_name                 = string
    local_network_name                        = string
    peer_network_name                         = string
    export_local_custom_routes                = optional(bool, false)
    export_peer_custom_routes                 = optional(bool, false)
    export_local_subnet_routes_with_public_ip = optional(bool, true)
    export_peer_subnet_routes_with_public_ip  = optional(bool, false)
    stack_type                                = optional(string, "IPV4_ONLY")
    # update_strategy                           = optional(string, "INDEPENDENT")
  }))
}

variable "network_attachments" {
  type = map(object({
    description           = optional(string, null)
    connection_preference = optional(string, "ACCEPT_AUTOMATIC")
    subnetwork_name       = list(string)
    producer_accept_lists = optional(list(string), [])
    producer_reject_lists = optional(list(string), [])
  }))
}

variable "vpc_firewall_rules" {
  type = map(object({
    name                    = string
    network                 = string
    project                 = string
    description             = optional(string, null)
    direction               = string
    disabled                = bool
    priority                = number
    ranges                  = optional(set(string), [])
    source_tags             = optional(set(string), null)
    source_service_accounts = optional(set(string), null)
    target_tags             = optional(set(string), null)
    target_service_accounts = optional(set(string), null)
    log_config = object({
      metadata = optional(string, "INCLUDE_ALL_METADATA")
    })
    allow = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
  }))
}

variable "pscendpoints" {
  type = map(object({
    network_name                            = string
    subnetwork_name                         = optional(string, "")
    project                                 = string
    region                                  = string
    address                                 = optional(string, null)
    create_regional_address                 = optional(bool, false)
    create_global_address                   = optional(bool, false)
    target_google_api                       = optional(string, null)
    access_type                             = optional(string, "REGIONAL")
    regional_endpoint_subnetwork            = optional(bool, false)
    target_service_attachment               = optional(string, null)
    allow_psc_global_access                 = optional(bool, false)
    no_automate_dns_zone                    = optional(bool, false)
    forwarding_rule_name                    = optional(string, null)
    service_attachment = optional(object({
      name                  = string
      description           = optional(string, null)
      target_service        = string
      nat_subnets           = list(string)
      connection_preference = string
      enable_proxy_protocol = optional(bool, false)
      reconcile_connections = optional(bool, false)
      domain_names          = optional(list(string), [])
      consumer_reject_lists = optional(list(string), [])
      consumer_accept_lists = optional(list(object({
        project_id_or_num = string
        connection_limit  = number
      })), [])
    }), null)
  }))
  default     = {}
  description = "Map of PSC Endpoints configurations."
}