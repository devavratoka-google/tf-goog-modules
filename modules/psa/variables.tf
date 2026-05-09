variable "network" {
  type        = string
  description = "(Required) Name of VPC network connected with service producers using VPC peering."
}

variable "reserved_peering_ranges" {
  type        = list(string)
  description = "(Required) Named IP address range(s) of PEERING type reserved for this service provider. Note that invoking this method with a different range when connection is already established will not reallocate already provisioned service producer subnetworks."
}