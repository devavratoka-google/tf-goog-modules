variable "name" {
  type = string
}
variable "network_endpoint_type" {
  type    = string
  default = "GCE_VM_IP_PORT"
}
variable "description" {
  type    = string
  default = null
}
variable "network" {
  type    = string
  default = null
}
variable "subnetwork" {
  type    = string
  default = null
}

# Specific to Zonal NEGs
variable "zone" {
  type    = string
  default = null
}
variable "default_port" {
  type    = number
  default = null
}

# ... (Keep existing variables) ...

variable "endpoints" {
  description = "A map of endpoints to attach to a Zonal NEG. Ignored for Serverless NEGs."
  type = map(object({
    instance   = string
    ip_address = string
    port       = number
  }))
  default = {}
}

# Specific to Regional Serverless NEGs
variable "region" {
  type    = string
  default = null
}

variable "cloud_run" {
  type = object({
    service  = optional(string)
    tag      = optional(string)
    url_mask = optional(string)
  })
  default = null
}

variable "cloud_function" {
  type = object({
    function = optional(string)
    url_mask = optional(string)
  })
  default = null
}

variable "app_engine" {
  type = object({
    service  = optional(string)
    version  = optional(string)
    url_mask = optional(string)
  })
  default = null
}