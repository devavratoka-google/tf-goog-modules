resource "google_cloud_scheduler_job" "this" {
  project          = var.project_id
  region           = var.region
  name             = var.name
  description      = var.description
  schedule         = var.schedule
  time_zone        = var.time_zone
  attempt_deadline = var.attempt_deadline
  paused           = var.paused

  dynamic "pubsub_target" {
    for_each = var.pubsub_target != null ? [var.pubsub_target] : []
    content {
      topic_name = pubsub_target.value.topic_name
      data       = try(base64encode(pubsub_target.value.data), null)
      attributes = pubsub_target.value.attributes
    }
  }

  dynamic "http_target" {
    for_each = var.http_target != null ? [var.http_target] : []
    content {
      uri         = http_target.value.uri
      http_method = http_target.value.http_method
      body        = try(base64encode(http_target.value.body), null)
      headers     = http_target.value.headers

      dynamic "oidc_token" {
        for_each = http_target.value.oidc_token != null ? [http_target.value.oidc_token] : []
        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = try(oidc_token.value.audience, null)
        }
      }

      dynamic "oauth_token" {
        for_each = http_target.value.oauth_token != null ? [http_target.value.oauth_token] : []
        content {
          service_account_email = oauth_token.value.service_account_email
          scope                 = oauth_token.value.scope
        }
      }
    }
  }

  dynamic "retry_config" {
    for_each = var.retry_config != null ? [var.retry_config] : []
    content {
      retry_count          = try(retry_config.value.retry_count, null)
      max_retry_duration   = try(retry_config.value.max_retry_duration, null)
      min_backoff_duration = try(retry_config.value.min_backoff_duration, null)
      max_backoff_duration = try(retry_config.value.max_backoff_duration, null)
      max_doublings        = try(retry_config.value.max_doublings, null)
    }
  }
}

resource "google_tags_location_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//cloudscheduler.googleapis.com/projects/${var.project_id}/locations/${var.region}/jobs/${google_cloud_scheduler_job.this.name}"
  tag_value = each.value
  location  = var.region
}

