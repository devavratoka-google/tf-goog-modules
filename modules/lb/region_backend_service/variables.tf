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
variable "load_balancing_scheme" {
  type    = string
  default = "INTERNAL_MANAGED"
}
variable "protocol" {
  type    = string
  default = "HTTP"
}
variable "port_name" {
  type    = string
  default = "http"
}
variable "timeout_sec" {
  type    = number
  default = 30
}
variable "connection_draining_timeout_sec" {
  type    = number
  default = 0
}
variable "health_checks" {
  type    = list(string)
  default = []
}
variable "enable_cdn" {
  type    = bool
  default = false
}

variable "log_config" {
  type = object({
    enable      = optional(bool, false)
    sample_rate = optional(number, 1.0)
  })
  default = null
}

variable "backends" {
  description = "A list of backends (Instance Groups or NEGs) attached to this service."
  type = list(object({
    group                        = string
    balancing_mode               = optional(string)
    capacity_scaler              = optional(number)
    description                  = optional(string)
    failover                     = optional(bool)
    max_connections              = optional(number)
    max_connections_per_endpoint = optional(number)
    max_connections_per_instance = optional(number)
    max_rate                     = optional(number)
    max_rate_per_endpoint        = optional(number)
    max_rate_per_instance        = optional(number)
    max_utilization              = optional(number)
  }))
  default = []
}