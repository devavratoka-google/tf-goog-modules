/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The ID of the project in which Pub/Sub resources are created."
  type        = string
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic."
  type        = string
}

variable "topic_labels" {
  description = "Labels to apply to the topic."
  type        = map(string)
  default     = {}
}

variable "message_retention_duration" {
  description = "Duration to retain undelivered messages in the topic (e.g., '86600s'). Defaults to the Pub/Sub platform default (7 days). Set to null to use the platform default."
  type        = string
  default     = null
}

variable "topic_iam" {
  description = "IAM bindings for the topic in {role => [members]} format. Non-authoritative (additive)."
  type        = map(list(string))
  default     = {}
}

variable "subscriptions" {
  description = "Map of subscription name to subscription configuration."
  type = map(object({
    # Common
    ack_deadline_seconds       = optional(number, 20)
    message_retention_duration = optional(string, "604800s")
    retain_acked_messages      = optional(bool, false)
    filter                     = optional(string, null)
    labels                     = optional(map(string), {})

    # Dead-letter policy — set topic to enable
    dead_letter_policy = optional(object({
      dead_letter_topic     = string
      max_delivery_attempts = optional(number, 5)
    }), null)

    # Retry policy
    retry_policy = optional(object({
      minimum_backoff = optional(string, "10s")
      maximum_backoff = optional(string, "600s")
    }), null)

    # Push config — set endpoint to create a push subscription; omit for pull
    push_config = optional(object({
      push_endpoint = string
      oidc_token = optional(object({
        service_account_email = string
        audience              = optional(string, null)
      }), null)
      attributes = optional(map(string), {})
    }), null)

    # BigQuery storage write subscription
    bigquery_config = optional(object({
      table               = string # projects/{project}/datasets/{dataset}/tables/{table}
      use_topic_schema    = optional(bool, false)
      write_metadata      = optional(bool, false)
      drop_unknown_fields = optional(bool, false)
    }), null)

    # IAM bindings on this subscription in {role => [members]} format
    iam = optional(map(list(string)), {})
  }))
  default = {}
}
