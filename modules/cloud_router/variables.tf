################ Start Variables for Cloud Router ################

variable "name" {
  type        = string
  description = "(Required) Name of the resource. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "network" {
  type        = string
  description = "value(Required) A reference to the network to which this router belongs."
}

variable "description" {
  type        = string
  description = "An optional description of this resource."
}

variable "asn" {
  type        = number
  description = "(Required) Local BGP Autonomous System Number (ASN). Must be an RFC6996 private ASN, either 16-bit or 32-bit. The value will be fixed for this router resource. All VPN tunnels that link to this router will have the same local ASN."
}

variable "advertise_mode" {
  type        = string
  description = "User-specified flag to indicate which mode to use for advertisement. Default value is DEFAULT. Possible values are: DEFAULT, CUSTOM."
}

variable "advertised_groups" {
  type        = list(string)
  description = "User-specified list of prefix groups to advertise in custom mode. This field can only be populated if advertiseMode is CUSTOM and is advertised to all peers of the router. These groups will be advertised in addition to any specified prefixes. Leave this field blank to advertise no custom groups. This enum field has the one valid value: ALL_SUBNETS"
}

variable "advertised_ip_ranges" {
  type = map(object({
    range       = string // (Required) The IP range to advertise. The value must be a CIDR-formatted string.
    description = string // User-specified description for the IP range.
  }))
  description = "User-specified list of individual IP ranges to advertise in custom mode. This field can only be populated if advertiseMode is CUSTOM and is advertised to all peers of the router. These IP ranges will be advertised in addition to any specified groups. Leave this field blank to advertise no custom IP ranges."
}

variable "keepalive_interval" {
  type        = number
  description = "The interval in seconds between BGP keepalive messages that are sent to the peer. Hold time is three times the interval at which keepalive messages are sent, and the hold time is the maximum number of seconds allowed to elapse between successive keepalive messages that BGP receives from a peer. BGP will use the smaller of either the local hold time value or the peer's hold time value as the hold time for the BGP connection between the two peers. If set, this value must be between 20 and 60. The default is 20."
}

variable "identifier_range" {
  type        = string
  description = "Explicitly specifies a range of valid BGP Identifiers for this Router. It is provided as a link-local IPv4 range (from 169.254.0.0/16), of size at least /30, even if the BGP sessions are over IPv6. It must not overlap with any IPv4 BGP session ranges. Other vendors commonly call this router ID."
}

variable "encrypted_interconnect_router" {
  type        = bool
  description = "Indicates if a router is dedicated for use with encrypted VLAN attachments (interconnectAttachments)."
}

variable "region" {
  type        = string
  description = "Region where the router resides."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

################ End Variables for Cloud Router ################

// New block of variables

################ Start Variables for Cloud Router Interfaces  ################

variable "router_interfaces" {
  type = map(object({
    interface_name = string // (Required) A unique name for the interface, required by GCE. Changing this forces a new interface to be created.
    ip_range       = string // IP address and range of the interface. The IP range must be in the RFC3927 link-local IP space. Changing this forces a new interface to be created.
    ip_version     = string // IP version of this interface. Can be either IPV4 or IPV6.
    // Only one of vpn_tunnel, interconnect_attachment or subnetwork can be specified.
    vpn_tunnel              = string // The name or resource link to the VPN tunnel this interface will be linked to. Changing this forces a new interface to be created.
    interconnect_attachment = string // The name or resource link to the VLAN interconnect for this interface. Changing this forces a new interface to be created.
    redundant_interface     = string // The name of the interface that is redundant to this interface. Changing this forces a new interface to be created.
    subnetwork              = string // The URI of the subnetwork resource that this interface belongs to, which must be in the same region as the Cloud Router. When you establish a BGP session to a VM instance using this interface, the VM instance must belong to the same subnetwork as the subnetwork specified here. Changing this forces a new interface to be created.
    private_ip_address      = string // The regional private internal IP address that is used to establish BGP sessions to a VM instance acting as a third-party Router Appliance. Changing this forces a new interface to be created.
  }))
}

################ End Variables for Cloud Router Interfaces  ################

// New block of variables

################ Start Variables for Cloud Router Peers ################

variable "router_peers" {
  type = map(object({
    peer_name                 = string
    interface                 = string
    peer_asn                  = number
    ip_address                = string
    peer_ip_address           = string
    advertised_route_priority = number
    advertise_mode            = string
    advertised_groups         = list(string)
    advertised_ip_ranges = map(object({
      range       = string
      description = string
    }))
    # custom_learned_route_priority = number
    # custom_learned_ip_ranges = map(object({
    #   range = string
    # }))
    bfd = map(object({
      session_initialization_mode = string
      min_receive_interval        = number
      min_transmit_interval       = number
      multiplier                  = number
    }))
    enable                    = bool
    router_appliance_instance = string
    enable_ipv6               = bool
    enable_ipv4               = bool
    # ipv4_nexthop_address      = string
    # ipv6_nexthop_address      = string
    # peer_ipv4_nexthop_address = string
    # peer_ipv6_nexthop_address = string
    md5_authentication_key = map(object({
      name = string
      key  = string
    }))
  }))
}

################ End Variables for Cloud Router Peers ################