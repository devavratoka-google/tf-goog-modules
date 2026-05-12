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

variable "default_service" {
  type        = string
  description = "The self_link of the default region backend service."
}

variable "ssl_certificates" {
  type    = list(string)
  default = []
}

variable "hosts" {
  description = "List of host headers to match (e.g., ['internal-lb.example.com'])"
  type        = list(string)
  default     = []
}