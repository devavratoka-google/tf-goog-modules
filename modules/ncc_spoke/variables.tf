variable "name" {
  type        = string
  description = "(Required) Immutable. The name of the spoke. Spoke names must be unique."
}

variable "hub" {
  type        = string
  description = "(Required) Immutable. The URI of the hub that this spoke is attached to."
}

variable "location" {
  type        = string
  description = "(Required) The location for the resource"
}

variable "labels" {
  type        = map(string)
  description = "Optional labels in key:value format. For more information about labels, see Requirements for labels. Note: This field is non-authoritative, and will only manage the labels present in your configuration. Please refer to the field effective_labels for all of the labels present on the resource."
}

variable "description" {
  type        = string
  description = "An optional description of the spoke."
}

variable "group" {
  type        = string
  description = "The name of the group that this spoke is associated with."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."

}

variable "linked_interconnect_attachments" {
  type = map(object({
    uris                       = list(string) // (Required) The URIs of linked interconnect attachment resources
    site_to_site_data_transfer = bool         // Required) A value that controls whether site-to-site data transfer is enabled for these resources. Note that data transfer is available only in supported locations.
    include_import_ranges      = list(string) // Hub routes fully encompassed by include import ranges are included during import from hub. "ALL_IPV4_RANGES" or IPv4 CIDR ranges are allowed.
    exclude_import_ranges      = list(string) // Hub routes overlapped/encompassed by exclude import ranges are excluded during import from hub.
    include_export_ranges      = list(string) // Dynamic routes fully encompassed by include export ranges are included during export to hub.
    exclude_export_ranges      = list(string) // Dynamic routes overlapped/encompassed by exclude export ranges are excluded during export to hub.
  }))
  description = "A collection of VLAN attachment resources. These resources should be redundant attachments that all advertise the same prefixes to Google Cloud. Alternatively, in active/passive configurations, all attachments should be capable of advertising the same prefixes."
}

variable "linked_vpn_tunnels" {
  type = map(object({
    uris                       = list(string) // (Required) The URIs of linked VPN tunnel resources.
    site_to_site_data_transfer = bool         // (Required) A value that controls whether site-to-site data transfer is enabled for these resources. Note that data transfer is available only in supported locations.
    include_import_ranges      = list(string) // Hub routes fully encompassed by include import ranges are included during import from hub. "ALL_IPV4_RANGES" or IPv4 CIDR ranges are allowed.
    exclude_import_ranges      = list(string) // Hub routes overlapped/encompassed by exclude import ranges are excluded during import from hub.
    include_export_ranges      = list(string) // Dynamic routes fully encompassed by include export ranges are included during export to hub.
    exclude_export_ranges      = list(string) // Dynamic routes overlapped/encompassed by exclude export ranges are excluded during export to hub.
  }))
  description = "The URIs of linked VPN tunnel resources"
}

variable "linked_vpc_network" {
  type = map(object({
    uri                   = string       // (Required) The URI of the VPC network resource.
    exclude_export_ranges = list(string) // IP ranges encompassing the subnets to be excluded from peering.
    include_export_ranges = list(string) // IP ranges allowed to be included from peering.
  }))
  description = "VPC network that is associated with the spoke."
}

variable "linked_producer_vpc_network" {
  type = map(object({
    network = string // (Required) The URI of the Service Consumer VPC that the Producer VPC is peered with.
    peering = string // (Required) The name of the VPC peering between the Service Consumer VPC and the Producer VPC (defined in the Tenant project) which is added to the NCC hub. This peering must be in ACTIVE state.
    # producer_network      = string       // The URI of the Producer VPC.
    include_export_ranges = list(string) // IP ranges allowed to be included from peering.
    exclude_export_ranges = list(string) // IP ranges encompassing the subnets to be excluded from peering.
  }))
  description = "Producer VPC network that is associated with the spoke."
}

variable "linked_router_appliance_instances" {
  type = map(object({
    site_to_site_data_transfer = bool         // (Required) A value that controls whether site-to-site data transfer is enabled for these resources. Note that data transfer is available only in supported locations.
    include_import_ranges      = list(string) // Hub routes fully encompassed by include import ranges are included during import from hub. "ALL_IPV4_RANGES" or IPv4 CIDR ranges are allowed.
    exclude_import_ranges      = list(string) // Hub routes overlapped/encompassed by exclude import ranges are excluded during import from hub.
    include_export_ranges      = list(string) // Dynamic routes fully encompassed by include export ranges are included during export to hub.
    exclude_export_ranges      = list(string) // Dynamic routes overlapped/encompassed by exclude export ranges are excluded during export to hub.
    instances = map(object({                  // (Required) The list of router appliance instances
      virtual_machine = string                // (Required) The URI of the virtual machine resource
      ip_address      = string                // (Required) The IP address on the VM to use for peering.
    }))
  }))
  description = "The URIs of linked Router appliance resources"
}