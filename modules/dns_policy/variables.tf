variable "project" {
  description = "The ID of the project where the DNS policy will be created"
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the DNS policy"
}

variable "enable_inbound_forwarding" {
  type        = bool
  description = "Whether to enable inbound forwarding"
  default     = false
}

variable "enable_logging" {
  type        = bool
  description = "Whether to enable logging for the policy"
  default     = false
}

variable "networks" {
  type        = list(string)
  description = "The list of VPC networks that this policy applies to"
  default     = []
}
