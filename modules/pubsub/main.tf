resource "google_pubsub_topic" "this" {
  project                    = var.project_id
  name                       = var.topic_name
  labels                     = var.labels
  message_retention_duration = var.message_retention_duration
}

resource "google_pubsub_subscription" "this" {
  for_each = var.subscriptions

  project = var.project_id
  name    = each.key
  topic   = google_pubsub_topic.this.name
  labels  = each.value.labels

  ack_deadline_seconds       = each.value.ack_deadline_seconds
  retain_acked_messages      = each.value.retain_acked_messages
  message_retention_duration = each.value.message_retention_duration

  dynamic "push_config" {
    for_each = each.value.push_config != null ? [each.value.push_config] : []
    content {
      push_endpoint = push_config.value.push_endpoint

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
}

locals {
  topic_iam_members = flatten([
    for role, members in var.topic_iam : [
      for member in members : {
        role   = role
        member = member
      }
    ]
  ])

  sub_iam_members = flatten([
    for sub_key, sub_val in var.subscriptions : [
      for role, members in try(sub_val.iam, {}) : [
        for member in members : {
          sub_key = sub_key
          role    = role
          member  = member
        }
      ]
    ]
  ])
}

resource "google_pubsub_topic_iam_member" "this" {
  for_each = { for item in local.topic_iam_members : "${item.role}#${item.member}" => item }

  project = var.project_id
  topic   = google_pubsub_topic.this.name
  role    = each.value.role
  member  = each.value.member
}

resource "google_pubsub_subscription_iam_member" "this" {
  for_each = { for item in local.sub_iam_members : "${item.sub_key}#${item.role}#${item.member}" => item }

  project      = var.project_id
  subscription = google_pubsub_subscription.this[each.value.sub_key].name
  role         = each.value.role
  member       = each.value.member
}
