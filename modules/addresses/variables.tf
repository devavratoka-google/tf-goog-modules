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

variable "labels" {
  type        = map(string)
  description = "A map of labels to assign to the resource."
  default     = null

  # 1. Enforce that the 'environment' key MUST exist
  validation {
    condition     = var.labels == null || can(var.labels["environment"])
    error_message = "Validation Error: The 'environment' label is mandatory."
  }
  # 2. Enforce that the 'applicationid' key MUST exist
  validation {
    condition     = var.labels == null || can(var.labels["applicationid"])
    error_message = "Validation Error: The 'applicationid' label is mandatory."
  }
}