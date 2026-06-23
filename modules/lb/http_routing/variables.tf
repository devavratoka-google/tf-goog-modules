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
  description = "Self-link of a regional SSL policy to attach to the HTTPS proxy. Only applied when ssl_certificates is non-empty. Use this to enforce minimum TLS versions and cipher profiles."
  type        = string
  default     = null
}

variable "path_rules" {
  description = "List of path rules for the default path matcher. Each rule maps one or more URL path patterns to a backend service, with an optional route action (e.g., url_rewrite for path prefix stripping). Applied in order; the url_map default_service catches anything not matched."
  type = list(object({
    paths   = list(string)
    service = string
    route_action = optional(object({
      url_rewrite = optional(object({
        path_prefix_rewrite = string
      }))
    }))
  }))
  default = []
}