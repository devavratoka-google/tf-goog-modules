variable "project_id" { type = string }

variable "notification_channels" {
  description = "Map of channel display_name => channel config object."
  type = map(object({
    type   = string
    labels = map(string)
  }))
  default = {}
}

variable "uptime_checks" {
  description = "Map of display_name => uptime check config."
  type = map(object({
    display_name = string
    timeout      = string
    period       = optional(string, "300s")
    http_check = optional(object({
      path         = optional(string, "/")
      port         = optional(number, 443)
      use_ssl      = optional(bool, true)
      validate_ssl = optional(bool, true)
    }))
    monitored_resource = object({
      type   = string
      labels = map(string)
    })
  }))
  default = {}
}

variable "alert_policies" {
  description = "Map of display_name => alert policy config. Use 'any' type to accommodate varied condition schemas."
  type        = map(any)
  default     = {}
}
