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

variable "cloud_scheduler_jobs" {
  description = "Map of Cloud Scheduler job configurations. Key is used as the job name."
  default     = {}
  type = map(object({
    project_id       = optional(string, null)
    region           = string
    schedule         = string
    description      = optional(string, null)
    time_zone        = optional(string, "Etc/UTC")
    attempt_deadline = optional(string, null)
    paused           = optional(bool, false)

    retry_config = optional(object({
      retry_count          = optional(number)
      max_retry_duration   = optional(string)
      min_backoff_duration = optional(string)
      max_backoff_duration = optional(string)
      max_doublings        = optional(number)
    }), null)

    http_target = optional(object({
      uri         = string
      http_method = optional(string, "POST")
      body        = optional(string)
      headers     = optional(map(string), {})
      oauth_token = optional(object({
        service_account_email = string
        scope                 = optional(string)
      }))
      oidc_token = optional(object({
        service_account_email = string
        audience              = optional(string)
      }))
    }), null)

    pubsub_target = optional(object({
      topic_name = string
      data       = optional(string)
      attributes = optional(map(string), {})
    }), null)

    app_engine_http_target = optional(object({
      relative_uri = string
      http_method  = optional(string)
      body         = optional(string)
      headers      = optional(map(string), {})
      app_engine_routing = optional(object({
        service  = optional(string)
        version  = optional(string)
        instance = optional(string)
      }))
    }), null)
  }))
}
