variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "schedule" {
  description = "Cron schedule (e.g. '0 0 * * *')"
  type        = string
}

variable "time_zone" {
  type    = string
  default = "UTC"
}

variable "attempt_deadline" {
  type    = string
  default = "180s"
}

variable "paused" {
  type    = bool
  default = false
}

variable "pubsub_target" {
  description = "Pub/Sub target. Set when the job publishes to a topic."
  type = object({
    topic_name = string
    data       = optional(string)
    attributes = optional(map(string), {})
  })
  default = null
}

variable "http_target" {
  description = "HTTP target. Set when the job calls an HTTP endpoint."
  type = object({
    uri         = string
    http_method = optional(string, "POST")
    body        = optional(string)
    headers     = optional(map(string), {})
    oidc_token = optional(object({
      service_account_email = string
      audience              = optional(string)
    }))
  })
  default = null
}
