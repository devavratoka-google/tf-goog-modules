# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "role_id" {
  description = "The role id to use for this role. Must be camelCase, 3-64 chars, alphanumeric+underscores. Final role name is 'projects/{project}/roles/{role_id}' or 'organizations/{org}/roles/{role_id}'."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\.]{3,64}$", var.role_id))
    error_message = "role_id must be 3-64 characters, alphanumeric, dots or underscores."
  }
}

variable "title" {
  description = "Human-readable title shown in the GCP IAM console."
  type        = string
  nullable    = false
}

variable "description" {
  description = "Optional human-readable description."
  type        = string
  nullable    = true
  default     = null
}

variable "permissions" {
  description = "List of GCP permissions (e.g. 'bigquery.datasets.get') granted by this custom role."
  type        = list(string)
  nullable    = false
  validation {
    condition     = length(var.permissions) > 0
    error_message = "permissions must contain at least one permission."
  }
}

variable "stage" {
  description = "Launch stage of the custom role. One of ALPHA, BETA, GA, DEPRECATED, DISABLED, EAP."
  type        = string
  nullable    = false
  default     = "GA"
  validation {
    condition     = contains(["ALPHA", "BETA", "GA", "DEPRECATED", "DISABLED", "EAP"], var.stage)
    error_message = "stage must be one of ALPHA, BETA, GA, DEPRECATED, DISABLED, EAP."
  }
}

variable "project_id" {
  description = "Project id where this custom role lives. Mutually exclusive with org_id."
  type        = string
  nullable    = true
  default     = null
}

variable "org_id" {
  description = "Organization id where this custom role lives. Mutually exclusive with project_id."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = !(var.org_id != null && var.project_id != null)
    error_message = "Set exactly one of project_id or org_id, not both."
  }
  validation {
    condition     = var.org_id != null || var.project_id != null
    error_message = "Set exactly one of project_id or org_id."
  }
}
