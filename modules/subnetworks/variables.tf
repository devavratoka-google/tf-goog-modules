variable "project" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "network" {
  description = "The network this subnet belongs to. Only networks that are in the distributed mode can have subnetworks."
  type        = string
}

variable "name" {
  type        = string
  description = "(Required) The name of the resource, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "description" {
  type        = string
  description = "An optional description of this resource. Provide this property when you create the resource. This field can be set only at resource creation time."
}

variable "ip_cidr_range" {
  type        = string
  description = "The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported. Field is optional when reserved_internal_range is defined, otherwise required."
}

variable "reserved_internal_range" {
  type        = string
  description = "The ID of the reserved internal range. Must be prefixed with networkconnectivity.googleapis.com E.g. networkconnectivity.googleapis.com/projects/{project}/locations/global/internalRanges/{rangeId}"
}

variable "purpose" {
  type        = string
  description = <<EOF
  The purpose of the resource. This field can be either PRIVATE, REGIONAL_MANAGED_PROXY, GLOBAL_MANAGED_PROXY, PRIVATE_SERVICE_CONNECT, PEER_MIGRATION or PRIVATE_NAT(Beta). 
  A subnet with purpose set to REGIONAL_MANAGED_PROXY is a user-created subnetwork that is reserved for regional Envoy-based load balancers. A subnetwork in a given region with purpose set to GLOBAL_MANAGED_PROXY is a proxy-only subnet and is shared between all the cross-regional Envoy-based load balancers. 
  A subnetwork with purpose set to PRIVATE_SERVICE_CONNECT reserves the subnet for hosting a Private Service Connect published service. A subnetwork with purpose set to PEER_MIGRATION is a user created subnetwork that is reserved for migrating resources from one peered network to another. 
  A subnetwork with purpose set to PRIVATE_NAT is used as source range for Private NAT gateways. 
  Note that REGIONAL_MANAGED_PROXY is the preferred setting for all regional Envoy load balancers. If unspecified, the purpose defaults to PRIVATE.
  EOF
}

variable "role" {
  type        = string
  description = "The role of subnetwork. Currently, this field is only used when purpose is REGIONAL_MANAGED_PROXY. The value can be set to ACTIVE or BACKUP. An ACTIVE subnetwork is one that is currently being used for Envoy-based load balancers in a region. A BACKUP subnetwork is one that is ready to be promoted to ACTIVE or is currently draining. Possible values are: ACTIVE, BACKUP."
}

variable "private_ip_google_access" {
  type        = bool
  description = "When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access."
}

variable "private_ipv6_google_access" {
  type        = string
  description = "The private IPv6 google access type for the VMs in this subnet."
}

variable "region" {
  type        = string
  description = "The GCP region for this subnetwork."
}

variable "stack_type" {
  type        = string
  description = "The stack type for this subnet to identify whether the IPv6 feature is enabled or not. If not specified IPV4_ONLY will be used. Possible values are: IPV4_ONLY, IPV4_IPV6, IPV6_ONLY."
}

variable "ipv6_access_type" {
  type        = string
  description = " The access type of IPv6 address this subnet holds. It's immutable and can only be specified during creation or the first time the subnet is updated into IPV4_IPV6 dual stack. If the ipv6_type is EXTERNAL then this subnet cannot enable direct path. Possible values are: EXTERNAL, INTERNAL."
}

variable "external_ipv6_prefix" {
  type        = string
  description = "The range of external IPv6 addresses that are owned by this subnetwork."
}

variable "send_secondary_ip_range_if_empty" {
  type        = bool
  description = "Controls the removal behavior of secondary_ip_range. When false, removing secondary_ip_range from config will not produce a diff as the provider will default to the API's value. When true, the provider will treat removing secondary_ip_range as sending an empty list of secondary IP ranges to the API. Defaults to false."
}

variable "secondary_ip_range" { // An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges. Note: This field uses attr-as-block mode to avoid breaking users during the 0.12 upgrade. To explicitly send a list of zero objects, set send_secondary_ip_range_if_empty = true
  type = map(object({
    range_name              = string // (Required) The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.
    ip_cidr_range           = string // The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only IPv4 is supported. Field is optional when reserved_internal_range is defined, otherwise required.
    reserved_internal_range = string // The ID of the reserved internal range. Must be prefixed with networkconnectivity.googleapis.com E.g. networkconnectivity.googleapis.com/projects/{project}/locations/global/internalRanges/{rangeId}
  }))
}

variable "log_config" {
  type = object({
    aggregation_interval = string      // Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of 5 seconds per connection. Default value is INTERVAL_5_SEC. Possible values are: INTERVAL_5_SEC, INTERVAL_30_SEC, INTERVAL_1_MIN, INTERVAL_5_MIN, INTERVAL_10_MIN, INTERVAL_15_MIN.
    flow_sampling        = number      // Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in [0, 1]. Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported. Default is 0.5 which means half of all collected logs are reported.
    metadata             = string      // Can only be specified if VPC flow logging for this subnetwork is enabled. Configures whether metadata fields should be added to the reported VPC flow logs. Default value is INCLUDE_ALL_METADATA. Possible values are: EXCLUDE_ALL_METADATA, INCLUDE_ALL_METADATA, CUSTOM_METADATA.
    metadata_fields      = set(string) // List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is enabled and 'metadata' is set to CUSTOM_METADATA.
    filter_expr          = string      // Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field. The default value is 'true', which evaluates to include everything.
  })
}
