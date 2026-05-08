# variable "name" {
#   type = string
#   description = "Name of the peering."
# }

# variable "network" {
#   type = string
#   description = "value"
# }

# variable "peer_network" {
#   type = string
#   description = "value"
# }

# variable "export_custom_routes" {
#   type = bool
#   description = "value"
# }

# variable "import_custom_routes" {
#   type = bool
#   description = "value"
# }

# variable "export_subnet_routes_with_public_ip" {
#   type = bool
#   description = "value"
# }

# variable "import_subnet_routes_with_public_ip" {
#   type = bool
#   description = "value"
# }

# variable "stack_type" {
#   type = string
#   description = "value"
# }

# variable "update_strategy" {
#   type = string
#   description = "value"
# }

###########################################################################

variable "local_network_peering_name" {
  type        = string
  description = "Name of the local peering."
}

variable "peer_network_peering_name" {
  type        = string
  description = "Name of the peer peering."
}

variable "local_network" {
  type        = string
  description = "The primary network of the peering."
}

variable "peer_network" {
  type        = string
  description = "The peer network in the peering. The peer network may belong to a different project."
}

variable "export_local_custom_routes" {
  type        = bool
  description = "Whether to export the custom routes to the peer network. Defaults to false."
}

variable "export_peer_custom_routes" {
  type        = bool
  description = "Whether to export the custom routes from the peer network. Defaults to false."
}

variable "export_local_subnet_routes_with_public_ip" {
  type        = bool
  description = "Whether subnet routes with public IP range are exported. The default value is true, all subnet routes are exported."
}

variable "export_peer_subnet_routes_with_public_ip" {
  type        = bool
  description = "Whether subnet routes with public IP range are imported. The default value is false."
}

variable "stack_type" {
  type        = string
  description = "Which IP version(s) of traffic and routes are allowed to be imported or exported between peer networks. The default value is IPV4_ONLY. Possible values: ['IPV4_ONLY', 'IPV4_IPV6']."
}

variable "update_strategy" {
  type        = string
  description = "The update strategy determines the semantics for updates and deletes to the peering connection configuration. The default value is INDEPENDENT. Possible values: ['INDEPENDENT', 'CONSENSUS']"
}

