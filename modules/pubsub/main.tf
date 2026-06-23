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

resource "google_pubsub_topic" "topic" {
  project = var.project_id
  name    = var.topic_name
  labels  = var.topic_labels

  dynamic "message_retention_duration" {
    for_each = var.message_retention_duration != null ? [var.message_retention_duration] : []
    content {
      # Expressed as a duration string (e.g. "86600s")
    }
  }

  # Inline: message_retention_duration is a top-level field, not a block.
  message_retention_duration = var.message_retention_duration
}

resource "google_pubsub_topic_iam_member" "topic_iam" {
  for_each = merge([
    for role, members in var.topic_iam : {
      for member in members : "${role}/${member}" => { role = role, member = member }
    }
  ]...)

  project = var.project_id
  topic   = google_pubsub_topic.topic.name
  role    = each.value.role
  member  = each.value.member
}

resource "google_pubsub_subscription" "subscriptions" {
  for_each = var.subscriptions

  project = var.project_id
  name    = each.key
  topic   = google_pubsub_topic.topic.id

  ack_deadline_seconds       = each.value.ack_deadline_seconds
  message_retention_duration = each.value.message_retention_duration
  retain_acked_messages      = each.value.retain_acked_messages
  filter                     = each.value.filter
  labels                     = each.value.labels

  dynamic "dead_letter_policy" {
    for_each = each.value.dead_letter_policy != null ? [each.value.dead_letter_policy] : []
    content {
      dead_letter_topic     = dead_letter_policy.value.dead_letter_topic
      max_delivery_attempts = dead_letter_policy.value.max_delivery_attempts
    }
  }

  dynamic "retry_policy" {
    for_each = each.value.retry_policy != null ? [each.value.retry_policy] : []
    content {
      minimum_backoff = retry_policy.value.minimum_backoff
      maximum_backoff = retry_policy.value.maximum_backoff
    }
  }

  dynamic "push_config" {
    for_each = each.value.push_config != null ? [each.value.push_config] : []
    content {
      push_endpoint = push_config.value.push_endpoint
      attributes    = push_config.value.attributes

      dynamic "oidc_token" {
        for_each = push_config.value.oidc_token != null ? [push_config.value.oidc_token] : []
        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = oidc_token.value.audience
        }
      }
    }
  }

  dynamic "bigquery_config" {
    for_each = each.value.bigquery_config != null ? [each.value.bigquery_config] : []
    content {
      table               = bigquery_config.value.table
      use_topic_schema    = bigquery_config.value.use_topic_schema
      write_metadata      = bigquery_config.value.write_metadata
      drop_unknown_fields = bigquery_config.value.drop_unknown_fields
    }
  }
}

resource "google_pubsub_subscription_iam_member" "subscription_iam" {
  for_each = merge([
    for sub_name, sub in var.subscriptions : merge([
      for role, members in sub.iam : {
        for member in members : "${sub_name}/${role}/${member}" => {
          subscription = sub_name
          role         = role
          member       = member
        }
      }
    ]...)
  ]...)

  project      = var.project_id
  subscription = google_pubsub_subscription.subscriptions[each.value.subscription].name
  role         = each.value.role
  member       = each.value.member
}
