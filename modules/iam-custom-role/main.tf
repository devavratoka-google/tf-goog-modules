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

locals {
  is_project_scope = var.project_id != null
  is_org_scope     = var.org_id != null
}

resource "google_project_iam_custom_role" "role" {
  count       = local.is_project_scope ? 1 : 0
  project     = var.project_id
  role_id     = var.role_id
  title       = var.title
  description = var.description
  permissions = var.permissions
  stage       = var.stage
}

resource "google_organization_iam_custom_role" "role" {
  count       = local.is_org_scope ? 1 : 0
  org_id      = var.org_id
  role_id     = var.role_id
  title       = var.title
  description = var.description
  permissions = var.permissions
  stage       = var.stage
}
