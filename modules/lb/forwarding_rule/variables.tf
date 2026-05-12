variable "name" {
  type = string
}
variable "region" {
  type = string
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
variable "ip_address" {
  type    = string
  default = null
}
variable "ip_protocol" {
  type    = string
  default = null
}
variable "ports" {
  type    = list(string)
  default = []
}
variable "port_range" {
  type    = string
  default = null
}
variable "backend_service" {
  type    = string
  default = null
}
variable "target" {
  type    = string
  default = null
}
variable "load_balancing_scheme" {
  type    = string
  default = "INTERNAL"
}
variable "allow_global_access" {
  type    = bool
  default = null
}
variable "network_tier" {
  type    = string
  default = null
}
variable "labels" {
  type    = map(string)
  default = {}
}

variable "service_directory_registrations" {
  description = "Service Directory registration configuration."
  type = object({
    namespace = optional(string)
    service   = optional(string)
  })
  default = null
}