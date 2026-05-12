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
variable "check_interval_sec" {
  type    = number
  default = 5
}
variable "timeout_sec" {
  type    = number
  default = 5
}
variable "healthy_threshold" {
  type    = number
  default = 2
}
variable "unhealthy_threshold" {
  type    = number
  default = 2
}

variable "log_config" {
  type = object({
    enable = optional(bool, false)
  })
  default = null
}

variable "tcp_health_check" {
  type = object({
    port               = optional(number)
    port_specification = optional(string)
    port_name          = optional(string)
    request            = optional(string)
    response           = optional(string)
    proxy_header       = optional(string)
  })
  default = null
}

variable "http_health_check" {
  type = object({
    port               = optional(number)
    port_specification = optional(string)
    port_name          = optional(string)
    host               = optional(string)
    request_path       = optional(string)
    response           = optional(string)
    proxy_header       = optional(string)
  })
  default = null
}

variable "https_health_check" {
  type = object({
    port               = optional(number)
    port_specification = optional(string)
    port_name          = optional(string)
    host               = optional(string)
    request_path       = optional(string)
    response           = optional(string)
    proxy_header       = optional(string)
  })
  default = null
}

variable "http2_health_check" {
  type = object({
    port               = optional(number)
    port_specification = optional(string)
    port_name          = optional(string)
    host               = optional(string)
    request_path       = optional(string)
    response           = optional(string)
    proxy_header       = optional(string)
  })
  default = null
}

variable "ssl_health_check" {
  type = object({
    port               = optional(number)
    port_specification = optional(string)
    port_name          = optional(string)
    request            = optional(string)
    response           = optional(string)
    proxy_header       = optional(string)
  })
  default = null
}

variable "grpc_health_check" {
  type = object({
    port               = optional(number)
    port_specification = optional(string)
    port_name          = optional(string)
    grpc_service_name  = optional(string)
  })
  default = null
}