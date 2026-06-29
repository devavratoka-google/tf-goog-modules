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

# Level 1: child folders of the parent
data "google_folders" "level1" {
  parent_id = "folders/${var.parent_folder_id}"
}

# Level 2: child folders of level 1
data "google_folders" "level2" {
  for_each  = toset([for f in data.google_folders.level1.folders : f.name])
  parent_id = each.value
}

# Level 3: child folders of level 2
data "google_folders" "level3" {
  for_each  = toset(flatten([for k, v in data.google_folders.level2 : [for f in v.folders : f.name]]))
  parent_id = each.value
}

locals {
  root_folder_name = "folders/${var.parent_folder_id}"

  level1_folder_names = [for f in data.google_folders.level1.folders : f.name]

  level2_folder_names = flatten([
    for parent, result in data.google_folders.level2 : [
      for f in result.folders : f.name
    ]
  ])

  level3_folder_names = flatten([
    for parent, result in data.google_folders.level3 : [
      for f in result.folders : f.name
    ]
  ])

  all_folder_names = distinct(concat(
    [local.root_folder_name],
    local.level1_folder_names,
    local.level2_folder_names,
    local.level3_folder_names
  ))

  # Extract the folder ID (number) from the "folders/number" string
  all_folder_ids = [for name in local.all_folder_names : split("/", name)[1]]
}

# Query projects under all collected folder IDs
data "google_projects" "by_folder" {
  for_each = toset(local.all_folder_ids)
  filter   = "parent.id:${each.value} parent.type:folder lifecycleState:ACTIVE"
}

locals {
  all_retrieved_projects = flatten([
    for folder_id, result in data.google_projects.by_folder : result.projects
  ])
}
