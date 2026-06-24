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

variable "project_id" {
  description = "The ID of the project in which the Cloud Scheduler job will be created."
  type        = string
}

variable "region" {
  description = "The region in which the Cloud Scheduler job resides."
  type        = string
}

variable "name" {
  description = "The name of the Cloud Scheduler job."
  type        = string
}

variable "schedule" {
  description = "Describes the schedule on which the job will be executed. The schedule is specified using unix-cron format."
  type        = string
}

variable "description" {
  description = "A human-readable description for the Cloud Scheduler job."
  type        = string
  default     = null
}

variable "time_zone" {
  description = "Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database. See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones."
  type        = string
  default     = "Etc/UTC"
}

variable "attempt_deadline" {
  description = "The deadline for job attempts. If the request handler does not respond by this deadline then the request is cancelled and the attempt is marked as a DEADLINE_EXCEEDED failure. The failed attempt can be viewed in execution logs. If this deadline is missed the cron job invocation may be retried. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: '3.5s'."
  type        = string
  default     = null
}

variable "paused" {
  description = "Sets the job to a paused state. Jobs default to being enabled when this property is not set."
  type        = bool
  default     = false
}

variable "retry_config" {
  description = "By default, if a job does not complete successfully, meaning that an acknowledgement is not received from the handler, then it will be retried with exponential backoff."
  type = object({
    retry_count          = optional(number)
    max_retry_duration   = optional(string)
    min_backoff_duration = optional(string)
    max_backoff_duration = optional(string)
    max_doublings        = optional(number)
  })
  default = null
}

variable "http_target" {
  description = "HTTP target configuration. Exactly one of http_target, pubsub_target or app_engine_http_target must be set."
  type = object({
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
  })
  default = null
}

variable "pubsub_target" {
  description = "Pub/Sub target configuration. Exactly one of http_target, pubsub_target or app_engine_http_target must be set."
  type = object({
    topic_name = string
    data       = optional(string)
    attributes = optional(map(string), {})
  })
  default = null
}

variable "app_engine_http_target" {
  description = "App Engine HTTP target configuration. Exactly one of http_target, pubsub_target or app_engine_http_target must be set."
  type = object({
    relative_uri = string
    http_method  = optional(string)
    body         = optional(string)
    headers      = optional(map(string), {})
    app_engine_routing = optional(object({
      service  = optional(string)
      version  = optional(string)
      instance = optional(string)
    }))
  })
  default = null
}
