variable "dest_range" {
  type        = string
  description = "The destination range of outgoing packets that this route applies to. Only IPv4 is supported."
}

variable "name" {
  type        = string
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression 'a-z?' which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "network" {
  type        = string
  description = "The network that this route applies to."
}

variable "description" {
  type        = string
  description = ""
}

variable "priority" {
  type        = number
  description = "The priority of this route. Priority is used to break ties in cases where there is more than one matching route of equal prefix length. In the case of two routes with equal prefix length, the one with the lowest-numbered priority value wins. Default value is 1000. Valid range is 0 through 65535."
}

variable "tags" {
  type        = set(string)
  description = "A list of instance tags to which this route applies."
}

variable "next_hop_gateway" {
  type        = string
  description = "URL to a gateway that should handle matching packets."
}

variable "next_hop_instance" {
  type        = string
  description = "URL to an instance that should handle matching packets."
}

variable "next_hop_ip" {
  type        = string
  description = "Network IP address of an instance that should handle matching packets."
}

variable "next_hop_vpn_tunnel" {
  type        = string
  description = "URL to a VpnTunnel that should handle matching packets."
}

variable "next_hop_ilb" {
  type        = string
  description = "The IP address or URL to a forwarding rule of type loadBalancingScheme=INTERNAL that should handle matching packets. With the GA provider you can only specify the forwarding rule as a partial or full URL."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "next_hop_instance_zone" {
  type        = string
  description = "(Optional when next_hop_instance is specified) The zone of the instance specified in next_hop_instance. Omit if next_hop_instance is specified as a URL."
}

variable "resource_manager_tags" {
  type        = map(string)
  description = "A set of key-value pairs to be used as resource manager tags. These tags are not applied to the underlying API resource, but are stored in the state file and can be used for filtering and other purposes."
}