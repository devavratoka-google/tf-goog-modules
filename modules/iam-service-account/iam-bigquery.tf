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

# Local-only divergence from upstream fabric iam-service-account v55.1.0:
# The upstream module does not cover BigQuery dataset bindings. This file
# implements roles granted *to* this service account on BQ datasets, in the
# same style as iam_project_roles / iam_storage_roles / etc.
#
# The var.iam_bigquery_dataset_roles uses keys of the form
# "project_id/dataset_id" so a single map can target datasets in any project.

locals {
  iam_bigquery_dataset_pairs = flatten([
    for entity, roles in var.iam_bigquery_dataset_roles : [
      for role in roles : {
        entity     = entity
        project    = split("/", entity)[0]
        dataset_id = split("/", entity)[1]
        role       = role
      }
    ]
  ])
}

resource "google_bigquery_dataset_iam_member" "bigquery-dataset-roles" {
  for_each = {
    for pair in local.iam_bigquery_dataset_pairs :
    "${pair.entity}-${pair.role}" => pair
  }
  project    = lookup(local.ctx.project_ids, each.value.project, each.value.project)
  dataset_id = each.value.dataset_id
  role       = lookup(local.ctx.custom_roles, each.value.role, each.value.role)
  member     = local.iam_email
}
