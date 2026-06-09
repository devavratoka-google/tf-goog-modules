variable "name" {
  type        = string
  description = "Name of the network attachment. Must be 1-63 characters long and comply with RFC1035."
}

variable "project" {
  type        = string
  description = "The ID of the project where the network attachment is created. This is the consumer project that owns the VPC/subnetwork (typically your own project, NOT the Cloud SQL tenant project)."
}

variable "region" {
  type        = string
  description = "Region where the network attachment resides."
}

variable "subnetworks" {
  type        = list(string)
  description = "Self-links (or URIs) of the subnetworks in your VPC that the producer (Cloud SQL instance) will use to reach your network."

  validation {
    condition     = length(var.subnetworks) > 0
    error_message = "At least one subnetwork must be provided."
  }
}

variable "connection_preference" {
  type        = string
  default     = "ACCEPT_AUTOMATIC"
  description = "Connection preference of the attachment. ACCEPT_AUTOMATIC always accepts connections; ACCEPT_MANUAL requires the producer project to be in producer_accept_lists."

  validation {
    condition     = contains(["ACCEPT_AUTOMATIC", "ACCEPT_MANUAL"], var.connection_preference)
    error_message = "connection_preference must be ACCEPT_AUTOMATIC or ACCEPT_MANUAL."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Optional description of the network attachment."
}

variable "producer_accept_lists" {
  type        = list(string)
  default     = []
  description = "Projects (id or number) allowed to connect to this attachment. Only used with ACCEPT_MANUAL. For Cloud SQL outbound, this is the Cloud SQL instance project."
}

variable "producer_reject_lists" {
  type        = list(string)
  default     = []
  description = "Projects (id or number) not allowed to connect to this attachment."
}
