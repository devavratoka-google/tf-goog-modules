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

output "id" {
  description = "Fully qualified custom role id, usable directly in IAM bindings (e.g. 'projects/X/roles/myRole' or 'organizations/Y/roles/myRole')."
  value = (
    local.is_project_scope
    ? google_project_iam_custom_role.role[0].id
    : google_organization_iam_custom_role.role[0].id
  )
}

output "name" {
  description = "Fully qualified custom role name. Same value as id; provided for naming compatibility with fabric modules."
  value = (
    local.is_project_scope
    ? google_project_iam_custom_role.role[0].name
    : google_organization_iam_custom_role.role[0].name
  )
}

output "role_id" {
  description = "Short role id (last path segment, e.g. 'myRole')."
  value       = var.role_id
}

output "permissions" {
  description = "Permissions granted by this custom role."
  value       = var.permissions
}

output "scope" {
  description = "Scope of the custom role: 'project' or 'organization'."
  value       = local.is_project_scope ? "project" : "organization"
}
