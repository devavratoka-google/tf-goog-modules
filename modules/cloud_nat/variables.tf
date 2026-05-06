################ Start Variables for Cloud NAT ################

variable "name" {
  description = "(Required) Name of the NAT service. The name must be 1-63 characters long and comply with RFC1035."
  type        = string
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "(Required) How NAT should be configured per Subnetwork. If ALL_SUBNETWORKS_ALL_IP_RANGES, all of the IP ranges in every Subnetwork are allowed to Nat. If ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, all of the primary IP ranges in every Subnetwork are allowed to Nat. LIST_OF_SUBNETWORKS: A list of Subnetworks are allowed to Nat (specified in the field subnetwork below). Note that if this field contains ALL_SUBNETWORKS_ALL_IP_RANGES or ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, then there should not be any other RouterNat section in any Router for this network in this region. Possible values are: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS."
  type        = string
  validation {
    condition     = contains(["ALL_SUBNETWORKS_ALL_IP_RANGES", "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES", "LIST_OF_SUBNETWORKS"], var.source_subnetwork_ip_ranges_to_nat)
    error_message = "Invalid value for source_subnetwork_ip_ranges_to_nat. Must be one of: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS."
  }
}

variable "router" {
  description = "(Required) The name of the Cloud Router in which this NAT will be configured."
  type        = string
}

variable "nat_ip_allocate_option" {
  description = "How external IPs should be allocated for this NAT. Valid values are AUTO_ONLY for only allowing NAT IPs allocated by Google Cloud Platform, or MANUAL_ONLY for only user-allocated NAT IP addresses. Possible values are: MANUAL_ONLY, AUTO_ONLY."
  type        = string
  validation {
    condition     = contains(["AUTO_ONLY", "MANUAL_ONLY"], var.nat_ip_allocate_option)
    error_message = "Invalid value for nat_ip_allocate_option. Must be one of: AUTO_ONLY, MANUAL_ONLY."
  }
}

# variable "initial_nat_ips" {
#   description = "Self-links of NAT IPs to be used as initial value for creation alongside a RouterNatAddress resource. Conflicts with natIps and drainNatIps. Only valid if natIpAllocateOption is set to MANUAL_ONLY."
#   type        = set(string)
# }

variable "nat_ips" {
  description = "Self-links of NAT IPs. Only valid if natIpAllocateOption is set to MANUAL_ONLY. If this field is used alongside with a count created list of address resources google_compute_address.foobar.*.self_link, the access level resource for the address resource must have a lifecycle block with create_before_destroy = true so the number of resources can be increased/decreased without triggering the resourceInUseByAnotherResource error."
  type        = set(string)
}

# variable "drain_nat_ips" {
#   description = "A list of URLs of the IP resources to be drained. These IPs must be valid static external IPs that have been assigned to the NAT."
#   type        = set(string)
# }

variable "subnetwork" {
  description = "One or more subnetwork NAT configurations. Only used if source_subnetwork_ip_ranges_to_nat is set to LIST_OF_SUBNETWORKS"
  type = map(object({
    name                     = string      // (Required) Self-link of subnetwork to NAT
    source_ip_ranges_to_nat  = set(string) // (Required) List of options for which source IPs in the subnetwork should have NAT enabled. Supported values include: ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE.
    secondary_ip_range_names = set(string) // List of the secondary ranges of the subnetwork that are allowed to use NAT. This can be populated only if LIST_OF_SECONDARY_IP_RANGES is one of the values in sourceIpRangesToNat
  }))
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT. Defaults to 64 for static port allocation and 32 dynamic port allocation if not set."
  type        = number
}

variable "max_ports_per_vm" {
  description = "Maximum number of ports allocated to a VM from this NAT. This field can only be set when enableDynamicPortAllocation is enabled."
  type        = number
}

variable "enable_dynamic_port_allocation" {
  description = "Enable Dynamic Port Allocation. If minPortsPerVm is set, minPortsPerVm must be set to a power of two greater than or equal to 32. If minPortsPerVm is not set, a minimum of 32 ports will be allocated to a VM from this NAT config. If maxPortsPerVm is set, maxPortsPerVm must be set to a power of two greater than minPortsPerVm. If maxPortsPerVm is not set, a maximum of 65536 ports will be allocated to a VM from this NAT config. Mutually exclusive with enableEndpointIndependentMapping."
  type        = bool
}

variable "udp_idle_timeout_sec" {
  description = "Timeout (in seconds) for UDP connections. Defaults to 30s if not set."
  type        = number
}

variable "icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections. Defaults to 30s if not set."
  type        = number
}

variable "tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set."
  type        = number
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set."
  type        = number
}

variable "tcp_time_wait_timeout_sec" {
  description = "Timeout (in seconds) for TCP connections that are in TIME_WAIT state. Defaults to 120s if not set."
  type        = number
}

# variable "log_config" {
#   description = "Configuration for logging on NAT Structure"
#   type = object({
#     enable = bool   // (Required) Indicates whether or not to export logs.
#     filter = string // (Required) Specifies the desired filtering of logs on this NAT. Possible values are: ERRORS_ONLY, TRANSLATIONS_ONLY, ALL.
#   })
# }

variable "enable" {
  type        = bool
  description = "(Required) Indicates whether or not to export logs."
}

variable "filter" {
  type        = string
  description = "(Required) Specifies the desired filtering of logs on this NAT. Possible values are: ERRORS_ONLY, TRANSLATIONS_ONLY, ALL."
}

variable "endpoint_types" {
  description = "Specifies the endpoint Types supported by the NAT Gateway. Supported values include: ENDPOINT_TYPE_VM, ENDPOINT_TYPE_SWG, ENDPOINT_TYPE_MANAGED_PROXY_LB"
  type        = list(string)
}

variable "rules" {
  description = "A list of rules associated with this NAT."
  type = map(object({
    rule_number = number                   // (Required) An integer uniquely identifying a rule in the list. The rule number must be a positive value between 0 and 65000, and must be unique among rules within a NAT.
    match       = string                   // (Required) CEL expression that specifies the match condition that egress traffic from a VM is evaluated against. If it evaluates to true, the corresponding action is enforced. The following examples are valid match expressions for public NAT: "inIpRange(destination.ip, '1.1.0.0/16') || inIpRange(destination.ip, '2.2.0.0/16')" "destination.ip == '1.1.0.1' || destination.ip == '8.8.8.8'" The following example is a valid match expression for private NAT: "nexthop.hub == 'https://networkconnectivity.googleapis.com/v1alpha1/projects/my-project/global/hub/hub-1'"
    description = string                   // An optional description of this rule.
    action = object({                      // The action to be enforced for traffic that matches this rule.
      source_nat_active_ips = list(string) // A list of URLs of the IP resources used for this NAT rule. These IP addresses must be valid static external IP addresses assigned to the project. This field is used for public NAT.
      source_nat_drain_ips  = list(string) // A list of URLs of the IP resources to be drained. These IPs must be valid static external IPs that have been assigned to the NAT. These IPs should be used for updating/patching a NAT rule only. This field is used for public NAT.
    })
  }))
}

variable "enable_endpoint_independent_mapping" {
  description = "Enable endpoint independent mapping."
  type        = bool
}

variable "type" {
  description = "Indicates whether this NAT is used for public or private IP translation. If unspecified, it defaults to PUBLIC. If PUBLIC NAT used for public IP translation. If PRIVATE NAT used for private IP translation. Default value is PUBLIC. Possible values are: PUBLIC, PRIVATE."
  type        = string
}

variable "auto_network_tier" {
  description = "The network tier to use when automatically reserving NAT IP addresses. Must be one of: PREMIUM, STANDARD. If not specified, then the current project-level default tier is used. Possible values are: PREMIUM, STANDARD."
  type        = string
}

variable "region" {
  description = "Region where the router and NAT reside."
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}

################ End Variables for Cloud NAT ################
