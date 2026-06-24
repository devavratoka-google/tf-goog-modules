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

variable "ssl_policy" {
  type        = string
  description = "Optional self-link of a regional SSL policy to apply to the target HTTPS proxy."
  default     = null
}

variable "path_rules" {
  description = "A list of path rules to apply to the path matcher. Each rule contains paths, service, and optional route_action."
  type = list(object({
    paths   = list(string)
    service = string
    route_action = optional(object({
      url_rewrite = optional(object({
        path_prefix_rewrite = string
        host_rewrite        = optional(string)
      }))
    }))
  }))
  default = []
}