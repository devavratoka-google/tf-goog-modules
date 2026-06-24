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

output "job" {
  description = "The created Cloud Scheduler job resource."
  value       = google_cloud_scheduler_job.this
}

output "name" {
  description = "The name of the Cloud Scheduler job."
  value       = google_cloud_scheduler_job.this.name
}

output "id" {
  description = "The unique identifier of the Cloud Scheduler job."
  value       = google_cloud_scheduler_job.this.id
}

output "state" {
  description = "State of the job. Values are ENABLED, PAUSED, DISABLED, UPDATE_FAILED, INITIALIZATION_FAILED."
  value       = google_cloud_scheduler_job.this.state
}
