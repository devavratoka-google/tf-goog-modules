/**
 * Copyright 2024 Google LLC
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

resource "google_cloud_scheduler_job" "this" {
  project          = var.project_id
  region           = var.region
  name             = var.name
  description      = var.description
  schedule         = var.schedule
  time_zone        = var.time_zone
  attempt_deadline = var.attempt_deadline
  paused           = var.paused

  dynamic "retry_config" {
    for_each = var.retry_config != null ? [var.retry_config] : []
    content {
      retry_count          = retry_config.value.retry_count
      max_retry_duration   = retry_config.value.max_retry_duration
      min_backoff_duration = retry_config.value.min_backoff_duration
      max_backoff_duration = retry_config.value.max_backoff_duration
      max_doublings        = retry_config.value.max_doublings
    }
  }

  dynamic "http_target" {
    for_each = var.http_target != null ? [var.http_target] : []
    content {
      uri         = http_target.value.uri
      http_method = http_target.value.http_method
      body        = http_target.value.body
      headers     = http_target.value.headers

      dynamic "oauth_token" {
        for_each = http_target.value.oauth_token != null ? [http_target.value.oauth_token] : []
        content {
          service_account_email = oauth_token.value.service_account_email
          scope                 = oauth_token.value.scope
        }
      }

      dynamic "oidc_token" {
        for_each = http_target.value.oidc_token != null ? [http_target.value.oidc_token] : []
        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = oidc_token.value.audience
        }
      }
    }
  }

  dynamic "pubsub_target" {
    for_each = var.pubsub_target != null ? [var.pubsub_target] : []
    content {
      topic_name = pubsub_target.value.topic_name
      data       = pubsub_target.value.data
      attributes = pubsub_target.value.attributes
    }
  }

  dynamic "app_engine_http_target" {
    for_each = var.app_engine_http_target != null ? [var.app_engine_http_target] : []
    content {
      http_method  = app_engine_http_target.value.http_method
      relative_uri = app_engine_http_target.value.relative_uri
      body         = app_engine_http_target.value.body
      headers      = app_engine_http_target.value.headers

      dynamic "app_engine_routing" {
        for_each = app_engine_http_target.value.app_engine_routing != null ? [app_engine_http_target.value.app_engine_routing] : []
        content {
          service  = app_engine_routing.value.service
          version  = app_engine_routing.value.version
          instance = app_engine_routing.value.instance
        }
      }
    }
  }
}
