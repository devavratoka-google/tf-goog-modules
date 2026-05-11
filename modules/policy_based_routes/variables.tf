variable "name" {
  type        = string
  description = "The name of the policy based route."
}

variable "network" {
  type        = string
  description = "The network to which this policy based route belongs."
}

variable "next_hop_other_routes" {
  type        = string
  description = "The list of other routes to which this policy based route will forward traffic."
}

variable "next_hop_ilb_ip" {
  type        = string
  description = "The IP address of the internal load balancer to which this policy based route will forward traffic."
}

variable "priority" {
  type        = number
  description = "The priority of this policy based route."
}

variable "project" {
  type        = string
  description = "The project to which this policy based route belongs."
}

variable "virtual_machine_tags" {
  type        = list(string)
  description = "The list of tags that will be applied to the virtual machines that match this policy based route."
  default     = [] # Add this line so the module caller doesn't have to pass an empty list
}

variable "src_range" {
  type        = string
  description = "The source range of this policy based route."
}

variable "dest_range" {
  type        = string
  description = "The destination range of this policy based route."
}

variable "ip_protocol" {
  type        = string
  description = "The IP protocol of this policy based route."
}

variable "protocol_version" {
  type        = string
  description = "The protocol version of this policy based route."
}