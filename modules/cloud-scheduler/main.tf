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
    }
  }
}
