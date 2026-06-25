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
  description = <<-EOT
    HTTP target. Set when the job calls an HTTP endpoint.

    Auth (set at most one):
      - oidc_token: an OIDC ID token with an audience claim — for invoking
        your own services (Cloud Run, Cloud Functions, IAP-protected apps).
      - oauth_token: an OAuth 2.0 access token with a scope — required when
        calling Google APIs (*.googleapis.com, e.g. Firestore export), which
        reject OIDC ID tokens. Defaults scope to cloud-platform.
  EOT
  type = object({
    uri         = string
    http_method = optional(string, "POST")
    body        = optional(string)
    headers     = optional(map(string), {})
    oidc_token = optional(object({
      service_account_email = string
      audience              = optional(string)
    }))
    oauth_token = optional(object({
      service_account_email = string
      scope                 = optional(string, "https://www.googleapis.com/auth/cloud-platform")
    }))
  })
  default = null
}

variable "retry_config" {
  description = "Optional retry configuration for the job."
  type = object({
    retry_count          = optional(number)
    max_retry_duration   = optional(string)
    min_backoff_duration = optional(string)
    max_backoff_duration = optional(string)
    max_doublings        = optional(number)
  })
  default = null
}
