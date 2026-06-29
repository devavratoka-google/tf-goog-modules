/**
 * Copyright 2026 Google LLC
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

output "projects" {
  description = "List of active projects retrieved."
  value = var.parent_folder_id == null ? [
    for p in data.google_projects.non_recursive[0].projects : {
      project_id = p.project_id
      name       = p.name
      number     = p.number
      labels     = p.labels
    }
  ] : [
    for r in data.google_cloud_asset_resources_search.recursive[0].results : {
      project_id = split("/", r.name)[4]
      name       = r.display_name
      number     = split("/", r.project)[1]
      labels     = {}
    }
  ]
}

output "project_ids" {
  description = "List of active project IDs retrieved."
  value = var.parent_folder_id == null ? [
    for p in data.google_projects.non_recursive[0].projects : p.project_id
  ] : [
    for r in data.google_cloud_asset_resources_search.recursive[0].results : split("/", r.name)[4]
  ]
}
