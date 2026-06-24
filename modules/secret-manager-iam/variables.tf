/**
 * Copyright 2021 Google LLC
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

variable "project_id" { type = string }

variable "secret_id" {
  description = "ID of an existing Secret Manager secret (not necessarily TF-managed)."
  type        = string
}

variable "accessors" {
  description = "List of IAM members to grant roles/secretmanager.secretAccessor."
  type        = list(string)
  default     = []
}

variable "role" {
  description = "IAM role to grant. Defaults to secretAccessor."
  type        = string
  default     = "roles/secretmanager.secretAccessor"
}
