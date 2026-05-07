variable "project" {
  description = "The ID of the project where the address will be created"
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the address"
}

variable "description" {
  type        = string
  description = "An optional description of this resource"
  default     = null
}

variable "address" {
  type        = string
  description = "The static IP address represented by this resource"
  default     = null
}

variable "address_type" {
  type        = string
  description = "The type of address to reserve: INTERNAL or EXTERNAL"
  default     = "EXTERNAL"
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource (e.g., GCE_ENDPOINT, VPC_PEERING)"
  default     = null
}

variable "network" {
  type        = string
  description = "The network this address belongs to (only for INTERNAL)"
  default     = null
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork this address belongs to (only for INTERNAL)"
  default     = null
}

variable "region" {
  type        = string
  description = "The region where the address will be created"
  default     = null
}
