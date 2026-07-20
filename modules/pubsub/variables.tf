variable "project_id" {
  description = "The ID of the project in which the Pub/Sub resources will be created."
  type        = string
}

variable "topic_name" {
  description = "The name of the Pub/Sub topic."
  type        = string
}

variable "labels" {
  description = "A map of labels to apply to the Pub/Sub topic."
  type        = map(string)
  default     = {}
}

variable "message_retention_duration" {
  description = "How long a Pub/Sub topic retains messages after transmission, in seconds. Must be between 3600s (1 hour) and 604800s (7 days). Defaults to null (no retention)."
  type        = string
  default     = null
}

variable "topic_iam" {
  description = "A map of roles to lists of members for additive topic-level IAM bindings."
  type        = map(list(string))
  default     = {}
}

variable "subscriptions" {
  description = "A map of Pub/Sub subscription configurations. The key is the subscription name."
  type = map(object({
    ack_deadline_seconds       = optional(number, 10)
    retain_acked_messages      = optional(bool, false)
    message_retention_duration = optional(string, null)
    labels                     = optional(map(string), {})

    push_config = optional(object({
      push_endpoint = string
      oidc_token = optional(object({
        service_account_email = string
        audience              = optional(string, null)
      }), null)
    }), null)

    bigquery_config = optional(object({
      table               = string
      use_topic_schema    = optional(bool, false)
      write_metadata      = optional(bool, false)
      drop_unknown_fields = optional(bool, false)
    }), null)

    dead_letter_policy = optional(object({
      dead_letter_topic     = string
      max_delivery_attempts = optional(number, 5)
    }), null)

    retry_policy = optional(object({
      minimum_backoff = optional(string, null)
      maximum_backoff = optional(string, null)
    }), null)

    iam = optional(map(list(string)), {})
  }))
  default = {}
}

variable "tag_bindings" {
  description = "Tag bindings for the Pub/Sub topic, in key => tag value id format."
  type        = map(string)
  default     = {}
}

