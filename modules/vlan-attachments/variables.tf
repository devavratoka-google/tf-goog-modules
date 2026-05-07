// VLAN Attachment Variables

variable "router" {
  description = "(Required) URL of the cloud router to be used for dynamic routing. This router must be in the same region as this InterconnectAttachment. The InterconnectAttachment will automatically connect the Interconnect to the network & region within which the Cloud Router is configured."
  type        = string
}

variable "name" {
  description = "(Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  type        = string
}

variable "region" {
  description = "Region where the regional interconnect attachment resides."
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}

variable "admin_enabled" {
  description = "Whether the VLAN attachment is enabled or disabled. When using PARTNER type this will Pre-Activate the interconnect attachment"
  type        = bool
}

variable "description" {
  description = "An optional description of this resource."
  type        = string
  default     = "VLAN Attachment"
}

variable "mtu" {
  description = "Maximum Transmission Unit (MTU), in bytes, of packets passing through this interconnect attachment. Valid values are 1440, 1460, 1500, and 8896. If not specified, the value will default to 1440."
  type        = number
  default     = 8896
}

variable "edge_availability_domain" {
  description = "Desired availability domain for the attachment. Only available for type PARTNER, at creation time. For improved reliability, customers should configure a pair of attachments with one per availability domain. The selected availability domain will be provided to the Partner via the pairing key so that the provisioned circuit will lie in the specified domain. If not specified, the value will default to AVAILABILITY_DOMAIN_ANY."
  type        = string
}

variable "type" {
  description = "The type of InterconnectAttachment you wish to create. Defaults to DEDICATED. Possible values are: DEDICATED, PARTNER, PARTNER_PROVIDER."
  type        = string
  default     = "PARTNER"
}

variable "vlan_tag8021q" {
  description = "The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094. When using PARTNER type this will be managed upstream."
  type        = number
  default     = null
}

variable "encryption" {
  description = "Indicates the user-supplied encryption option of this interconnect attachment. Can only be specified at attachment creation for PARTNER or DEDICATED attachments. NONE - This is the default value, which means that the VLAN attachment carries unencrypted traffic. VMs are able to send traffic to, or receive traffic from, such a VLAN attachment. IPSEC - The VLAN attachment carries only encrypted traffic that is encrypted by an IPsec device, such as an HA VPN gateway or third-party IPsec VPN. VMs cannot directly send traffic to, or receive traffic from, such a VLAN attachment. To use HA VPN over Cloud Interconnect, the VLAN attachment must be created with this option. Default value is NONE. Possible values are: NONE, IPSEC."
  type        = string
  default     = "NONE"
}

variable "labels" {
  description = "Labels for this resource. These can only be added or modified by the setLabels method. Each label key/value pair must comply with RFC1035. Label values may be empty."
  type        = map(string)
  default     = {}
}

// google_network_management_vpc_flow_logs_config Variables

variable "vpc_flow_logs_config_id" {
  description = "(Required) Required. ID of the VpcFlowLogsConfig."
  type        = string
}

variable "state" {
  description = "The state of the VPC Flow Log configuration. Default value is ENABLED. When creating a new configuration, it must be enabled."
  type        = string
}

variable "aggregation_interval" {
  description = "Optional. The aggregation interval for the logs. Default value is INTERVAL_5_SEC. Possible values: AGGREGATION_INTERVAL_UNSPECIFIED INTERVAL_5_SEC INTERVAL_30_SEC INTERVAL_1_MIN INTERVAL_5_MIN INTERVAL_10_MIN INTERVAL_15_MIN"
  type        = string
}

variable "flow_sampling" {
  description = "The value of the field must be in (0, 1]. The sampling rate of VPC Flow Logs where 1.0 means all collected logs are reported. Setting the sampling rate to 0.0 is not allowed. If you want to disable VPC Flow Logs, use the state field instead. Default value is 1.0."
  type        = number
}

variable "metadata" {
  description = "Configures whether all, none or a subset of metadata fields should be added to the reported VPC flow logs. Default value is INCLUDE_ALL_METADATA. Possible values: METADATA_UNSPECIFIED INCLUDE_ALL_METADATA EXCLUDE_ALL_METADATA CUSTOM_METADATA"
  type        = string
  default     = "INCLUDE_ALL_METADATA"
}

# variable "flow_log_labels" {
#   description = "Labels for this resource. These can only be added or modified by the setLabels method. Each label key/value pair must comply with RFC1035. Label values may be empty."
#   type        = map(string)
#   default     = {}
# }