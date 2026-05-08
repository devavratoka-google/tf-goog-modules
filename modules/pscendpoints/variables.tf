variable "project" {
  type        = string
  description = "The project ID to deploy resources in."
}

variable "network" {
  type        = string
  description = "The self-link of the network."
}

variable "subnetwork" {
  type        = string
  description = "The self-link of the subnetwork."
}

variable "region" {
  type        = string
  description = "The region to deploy resources in."
}

variable "address_name" {
  type        = string
  description = "Name of the compute address."
}

variable "address" {
  type        = string
  default     = null
  description = "The IP address to reserve. If null, one will be automatically allocated."
}

variable "target_google_api" {
  type        = string
  default     = null
  description = "The target Google API for the regional/global endpoint (e.g., storage.us-central1.rep.googleapis.com)."
}

variable "access_type" {
  type        = string
  default     = "REGIONAL"
  description = "Access type for the network connectivity endpoint. Can be REGIONAL or GLOBAL."
}

variable "regional_endpoint_subnetwork" {
  type        = bool
  default     = false
  description = "Set to true for global endpoint to use subnetwork."
}

variable "regional_endpoint_address_use_self_link" {
  type        = bool
  default     = false
  description = "Set to true to use self link for address in global endpoint."
}

variable "target_service_attachment" {
  type        = string
  default     = null
  description = "The target service attachment for the consumer forwarding rule."
}

variable "allow_psc_global_access" {
  type        = bool
  default     = false
  description = "Allow global access for PSC forwarding rule."
}

variable "no_automate_dns_zone" {
  type        = bool
  default     = false
  description = "Disable automatic DNS zone creation for PSC forwarding rule."
}

variable "forwarding_rule_name" {
  type        = string
  default     = null
  description = "Name of the forwarding rule."
}

variable "service_attachment" {
  type = object({
    name                  = string
    description           = optional(string)
    target_service        = string
    nat_subnets           = list(string)
    connection_preference = string
    enable_proxy_protocol = optional(bool, false)
    reconcile_connections = optional(bool, false)
    domain_names          = optional(list(string), [])
    consumer_reject_lists = optional(list(string), [])
    consumer_accept_lists = optional(list(object({
      project_id_or_num = string
      connection_limit  = number
    })), [])
  })
  default     = null
  description = "Configuration for the producer service attachment."
}
